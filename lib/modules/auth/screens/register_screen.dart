import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/widgets/general_button.dart';
import 'package:huicrochet_mobile/widgets/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image_profile;

  bool _isObscured = true;
  bool _isObscured2 = true;

  bool _emailTouched = false;
  bool _nameTouched = false;
  bool _passwordTouched = false;
  bool _repeatPasswordTouched = false;
  bool _birthdayTouched = false;

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  String? _validateEmail(String? value) {
    if (!_emailTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (!_nameTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_passwordTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    } else if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  String? _validateRepeatPassword(String? value) {
    if (!_repeatPasswordTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    } else if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? _validateBirthday(String? value) {
    if (!_birthdayTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor selecciona tu fecha de nacimiento';
    }
    if (DateFormat('dd/MM/yyyy').parse(value).isAfter(DateTime.now())) {
      return 'Por favor selecciona una fecha valida';
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
        _birthdayTouched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _nameController.addListener(_validateForm);
    _repeatPasswordController.addListener(_validateForm);
    _birthdayController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _repeatPasswordController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _formKey.currentState?.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'HUICROCHET',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(130, 48, 56, 1),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(135, 135, 135, 1),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '¡Bienvenido!',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color.fromRGBO(130, 48, 56, 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Registrarse',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(130, 48, 56, 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Calidad en cada puntada, arte en cada detalle.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Color.fromRGBO(130, 48, 56, 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateName,
                          onTap: () {
                            setState(() {
                              _nameTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _birthdayController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Fecha de nacimiento',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => _selectDate(context),
                          validator: _validateBirthday,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateEmail,
                          onTap: () {
                            setState(() {
                              _emailTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                color: const Color.fromRGBO(130, 48, 56, 1),
                                _isObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                          ),
                          validator: _validatePassword,
                          onTap: () {
                            setState(() {
                              _passwordTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _repeatPasswordController,
                          obscureText: _isObscured2,
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                color: const Color.fromRGBO(130, 48, 56, 1),
                                _isObscured2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscured2 = !_isObscured2;
                                });
                              },
                            ),
                          ),
                          validator: _validateRepeatPassword,
                          onTap: () {
                            setState(() {
                              _repeatPasswordTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: image_profile != null
                                ? Image.file(
                                    image_profile!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(
                                      color: Color.fromARGB(63, 142, 119, 119),
                                      width: 0.5),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Subir imagen de perfil',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              onPressed: () async {
                                final image = await getImage();
                                setState(() {
                                  image_profile = File(image!.path);
                                });
                              }),
                        ),
                        const SizedBox(height: 32),
                        GeneralButton(
                            text: 'Registrarse',
                            onPressed: () {
                              setState(() {
                                _nameTouched = true;
                                _emailTouched = true;
                                _passwordTouched = true;
                                _repeatPasswordTouched = true;
                                _birthdayTouched = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                _register(_emailController, _passwordController, _nameController, _birthdayController, context, image_profile);
                              }
                            }),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "¿Ya tienes cuenta? ",
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color.fromRGBO(130, 48, 56, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
        )));
  }
}
void _register(
  TextEditingController _emailController,
  TextEditingController _passwordController,
  TextEditingController _nameController,
  TextEditingController _birthdayController,
  BuildContext context,
  File? profileImage,
) async {
  final dio = DioClient(context).dio;

  try {
    String birthday = _birthdayController.text; 
    List<String> parts = birthday.split('/'); 
    String formattedBirthday = '${parts[2]}-${parts[1]}-${parts[0]}'; 

    FormData formData = FormData.fromMap({
      'user': jsonEncode({
        'fullName': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'birthday': formattedBirthday,
        "status": true,
        "blocked": true,
      }),
      if (profileImage != null)
        'profileImage': await MultipartFile.fromFile(
          profileImage.path,
          filename: 'profileImage.jpg',
        ),
    });

    // Enviar la petición
    final response = await dio.post(
      '/auth/createClient',
      data: formData,
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registro Exitoso"),
            content: Text("El usuario ha sido registrado correctamente."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/login');
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
      String errorMessage = e.response?.data['message'] ?? 'Error desconocido';
      errorState.setError(errorMessage); 
    } else {
      errorState.setError('Error de conexión');
    }
  } else {
    errorState.setError('Error inesperado: $e');
  }
  errorState.showErrorDialog(context);
}

}
