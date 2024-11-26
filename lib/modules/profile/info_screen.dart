import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/general/image_picker.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final LoaderController _loaderController = LoaderController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String name = '';
  String? initialEmail;
  String? initialName;
  String? initialBirthday;
  bool _isEdited = false;
  bool _isValid = false;
  String? userImg;

  String? fullName;
  File? image_profile;

  Future<void> getImg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('userImg');
    final imageName = imagePath?.split('/').last;
    final profileImage = 'http://$ip:8080/$imageName';

    setState(() {
      fullName = prefs.getString('fullName');
      userImg = profileImage;
    });
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;
    final imagePath = prefs.getString('userImg');
    final imageName = imagePath?.split('/').last;
    final profileImage = 'http://$ip:8080/$imageName';
    try {
      final response =
          await dio.get('/auth/findById/${prefs.getString('userId')}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.data);
        setState(() {
          initialName = jsonData['data']['fullName'];
          initialEmail = jsonData['data']['email'];
          initialBirthday = jsonData['data']['birthday'];
          name = jsonData['data']['fullName'];
          _nameController.text = initialName!;
          _emailController.text = initialEmail!;
          final parsedDate = DateTime.parse(initialBirthday!);
          _birthdayController.text =
              DateFormat('dd/MM/yyyy').format(parsedDate);
          userImg = prefs.getString('userImg');
          userImg = profileImage;
        });
        _loaderController.hide();
      }
    } catch (e) {
      final errorState = Provider.of<ErrorState>(context, listen: false);
      errorState.setError(e is DioException && e.response?.statusCode == 400
          ? e.response?.data['message'] ?? 'Error desconocido'
          : 'Error de conexión');
      errorState.showErrorDialog(context);
      _loaderController.hide();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      getProfile();
    });
    _birthdayController.text = 'Cargando...';
    _nameController.text = 'Cargando...';
    _emailController.text = 'Cargando...';
    name = 'Cargando...';
    _nameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _birthdayController.addListener(_checkForChanges);
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _birthdayController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _birthdayController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      _isEdited = _nameController.text != initialName ||
          _emailController.text != initialEmail ||
          _birthdayController.text !=
              DateFormat('dd/MM/yyyy').format(DateTime.parse(initialBirthday!));
    });
  }

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    return null;
  }

  String? _validateBirthday(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor selecciona tu fecha de nacimiento';
    }
    if (DateFormat('dd/MM/yyyy').parse(value).isAfter(DateTime.now())) {
      return 'Por favor selecciona una fecha válida';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> updateProfile() async {
    _loaderController.show(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;

    try {
      String birthday = _birthdayController.text;
      List<String> parts = birthday.split('/');
      String formattedBirthday =
          '${parts[2]}-${parts[1]}-${parts[0]}T00:00:00.000Z';

      final data = {
        'fullName': _nameController.text,
        'email': _emailController.text,
        'birthday': formattedBirthday,
      };

      final response = await dio.put(
        '/user/update/${prefs.getString('userId')}',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        _loaderController.hide();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Actualización Exitosa"),
              content: Text("Su información ha sido modificada correctamente."),
              actions: [
                TextButton(
                  onPressed: () {
                    prefs.setString('fullName', _nameController.text);
                    Navigator.pushReplacementNamed(context, '/navigation');
                  },
                  child: Text("Aceptar"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      final errorState = Provider.of<ErrorState>(context, listen: false);

      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          String errorMessage =
              e.response?.data['message'] ?? 'Error desconocido';
          errorState.setError(errorMessage);
        } else {
          errorState.setError('Error de conexión');
        }
      } else {
        errorState.setError('Error inesperado: $e');
      }
      _loaderController.hide();
      errorState.showErrorDialog(context);
    }
  }

  String getInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String initials = '';

    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }

    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), 
            color: Colors.black, 
            onPressed: () {
               Navigator.pushReplacementNamed(context, '/navigation');
            },
          ),
          title: Text('Información personal'),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 32),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: userImg != null
                          ? Image.network(
                              userImg!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                String initials = fullName != null
                                    ? getInitials(fullName!)
                                    : '??';
                                return CircleAvatar(
                                  backgroundColor: colors['wine'],
                                  child: Text(
                                    initials,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: colors['wine'],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 5.0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: colors['violet'],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: 20.0,
                          color: Colors.white,
                          onPressed: () async {
                            final image = await getImage();
                            setState(() {
                              image_profile = File(image!.path);
                              _updateProfilePicture(
                                  context, image_profile, getProfile);
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Text('Información personal',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: colors['wine'])),
                ),
                Divider(),
                Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre:',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 24),
                        Text('Correo:',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 24),
                        Text('Fecha de nacimiento:',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _birthdayController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => _selectDate(context),
                          validator: _validateBirthday,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: colors['violet'],
                            ),
                            onPressed:
                                _isEdited && _isValid ? updateProfile : null,
                            child: const Text('Guardar cambios',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Poppins')),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}

Future<void> _updateProfilePicture(
    BuildContext context, File? profileImage, Function onSuccess) async {
  final dio = DioClient(context).dio;

  try {
    if (profileImage != null) {
      String extension = profileImage.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        throw Exception(
            'El formato de la imagen no es válido. Solo se permiten jpg, jpeg y png.');
      }
    }

    String filename =
        profileImage != null ? profileImage.path.split('/').last : '';

    String mimeType = 'image/jpeg';
    FormData formData = FormData.fromMap({
      if (profileImage != null)
        'profileImage': await MultipartFile.fromFile(
          profileImage.path,
          filename: filename,
          contentType: DioMediaType.parse(mimeType),
        ),
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      throw Exception('No se encontró el ID del usuario.');
    }

    final response = await dio.put(
      '/user/updateProfileImage/$userId',
      data: formData,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.toString());
      final String updatedImageUrl =
          jsonData['data']['image']['imageUri'] as String;
      final imagePath = updatedImageUrl.split('/').last;
      final uriNetwork = 'http://$ip:8080/$imagePath';
      prefs.setString('userImg', uriNetwork);
      onSuccess();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Imagen de perfil actualizada"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Error al actualizar la imagen de perfil.');
    }
  } catch (e) {
    final errorState = Provider.of<ErrorState>(context, listen: false);
    if (e is DioException) {
      String errorMessage = e.response?.data['message'] ?? 'Error de conexión';
      errorState.setError(errorMessage);
    } else {
      errorState.setError('Error inesperado: ${e.toString()}');
    }

    errorState.showErrorDialog(context);
  }
}
