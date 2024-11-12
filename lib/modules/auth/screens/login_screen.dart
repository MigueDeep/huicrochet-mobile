import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/auth/use_cases/login_use_case.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final LoginUseCase loginUseCase;

  const LoginScreen({super.key, required this.loginUseCase});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoaderController _loaderController = LoaderController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  bool _isValid = false; // Para saber si los campos son válidos
  bool _emailTouched = false;
  bool _passwordTouched = false;

  // Validar el formato del correo
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (!_emailTouched) {
      return null; // Si el usuario no ha dado click en el campo, no se muestra el error
    }
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_passwordTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    return null;
  }

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _login(TextEditingController emailController,
      TextEditingController passwordController, BuildContext context) async {
    try {
      final result = await widget.loginUseCase.execute(
        emailController.text,
        passwordController.text,
      );

      if (result.success) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result.token ?? '');
        await prefs.setString('userId', result.userId ?? '');
        await prefs.setString('userImg', result.userImg ??'');
        await prefs.setString('fullName', result.fullName ??'');
        Navigator.pushReplacementNamed(context, '/navigation');
      } else {
        print(result.message);
      }
    } catch (e) {
      _showErrorDialog(
          'Error al iniciar sesión, por favor intente nuevamente.');
    }
  }

  // Mostrar un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
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
                          'Iniciar sesión',
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo',
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
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/recoverpass1');
                          },
                          child: const Text(
                            '¿Olvidaste la contraseña?',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GeneralButton(
                          text: 'Iniciar sesión',
                          onPressed: () async {
                            _loaderController.show(context);
                            setState(() {
                              _emailTouched = true;
                              _passwordTouched = true;
                            });

                            if (_formKey.currentState!.validate()) {
                              await _login(_emailController,
                                  _passwordController, context);
                              _loaderController.hide();
                            } else {
                              // Oculta el loader si la validación falla
                              _loaderController.hide();
                            }
                          }),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿Aún no tienes cuenta? ",
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}