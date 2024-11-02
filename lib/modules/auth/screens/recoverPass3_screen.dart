import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:provider/provider.dart';

class Recoverpass3Screen extends StatefulWidget {
  const Recoverpass3Screen(
      {super.key, required this.email, required this.code});
  final String email;
  final String code;

  @override
  _Recoverpass3ScreenState createState() => _Recoverpass3ScreenState();
}

class _Recoverpass3ScreenState extends State<Recoverpass3Screen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  bool _isObscured2 = true;
  bool _passwordTouched = false;
  bool _repeatPasswordTouched = false;

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  String? _validatePassword(String? value) {
    if (!_passwordTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    } else if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
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

  @override
  void initState() {
    super.initState();
    _repeatPasswordController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _repeatPasswordController.dispose();
    _passwordController.dispose();
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
        backgroundColor: Colors.white,
        body: Padding(
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
                            'Restablece tu contraseña',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(130, 48, 56, 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            labelText: 'Nueva contraseña',
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
                            onPressed: () {
                              setState(() {
                                _passwordTouched = true;
                                _repeatPasswordTouched = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                _changePass(widget.code, context, widget.email,
                                    _passwordController.text);
                                Navigator.pushNamed(context, '/login');
                              }
                            },
                            child: const Text('Restablecer contraseña',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Poppins')),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

void _changePass(
    String code, BuildContext context, String email, String password) async {
  print('Si no sales, hazme una llamada y yo cambio los planes: ');
  print(email);
  print(code);
  final dio = DioClient(context).dio;

  try {
    final response = await dio.post(
      '/auth/changePassword',
      queryParameters: {'token': code, 'email': email, 'password': password},
    );

    print(response.data);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Código verificado, ya puedes actualizar tu contraseña'),
          backgroundColor: Colors.blue,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
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

    errorState.showErrorDialog(context);
  }
}
