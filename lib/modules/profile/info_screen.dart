import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
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

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;
    final imagePath = prefs.getString('userImg');
    final imageName = imagePath?.split('/').last;
    final profileImage = 'http://${ip}:8080/$imageName';
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
          automaticallyImplyLeading: true,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    userImg ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      String initials =
                          name != null ? getInitials(name!) : '??';
                      return CircleAvatar(
                        backgroundColor: const Color.fromRGBO(242, 148, 165, 1),
                        child: Text(initials,
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
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
                          color: Color.fromRGBO(130, 48, 56, 1))),
                ),
                Divider(),
                Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
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
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
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
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
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
                              backgroundColor:
                                  const Color.fromRGBO(242, 148, 165, 1),
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
