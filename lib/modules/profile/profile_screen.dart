import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fullName;
  String? userImg;
  File? image_profile;

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('userImg');
    final imageName = imagePath?.split('/').last;
    final profileImage = 'http://$ip:8080/$imageName';

    setState(() {
      fullName = prefs.getString('fullName');
      userImg = profileImage;
    });
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No tienes sesión iniciada'),
            content: const Text('¿Quieres iniciar sesión'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/navigation');
                },
              ),
              TextButton(
                child: const Text('Iniciar sesión'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      );
    } else {
      getProfile();
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
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Perfil'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
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
                          String initials =
                              fullName != null ? getInitials(fullName!) : '??';
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
                        _updateProfilePicture(context, image_profile, getProfile);
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
          const SizedBox(height: 10),
          Text(
            fullName ?? 'Cargando...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            leading: Text('Mis ordenes',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: colors['wine'])),
            trailing: Icon(Icons.local_shipping, color: colors['wine']),
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          const Divider(),
          ListTile(
            trailing: Icon(Icons.person_outline, color: colors['wine']),
            leading: Text('Información personal',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: colors['wine'])),
            onTap: () {
              Navigator.pushNamed(context, '/info');
            },
          ),
          const Divider(),
          ListTile(
            trailing: Icon(Icons.location_on_outlined, color: colors['wine']),
            leading: Text('Direcciones',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: colors['wine'])),
            onTap: () {
              Navigator.pushNamed(context, '/addresses');
            },
          ),
          const Divider(),
          ListTile(
            trailing: Icon(Icons.credit_card, color: colors['wine']),
            leading: Text('Métodos de pago',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: colors['wine'])),
            onTap: () {
              Navigator.pushNamed(context, '/my-payment-methods');
            },
          ),
          const Divider(),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: GeneralButton(
                text: 'Cerrar sesión',
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('token');
                  prefs.remove('fullName');
                  prefs.remove('userId');
                  prefs.remove('userImg');
                  prefs.remove('shoppingCartId');
                  Navigator.pushReplacementNamed(context, '/login');
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

Future<void> _updateProfilePicture(
  BuildContext context,
  File? profileImage,
  Function onSuccess
) async {
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
      final String updatedImageUrl = jsonData['data']['image']['imageUri'] as String;
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
