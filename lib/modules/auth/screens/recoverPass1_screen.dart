import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/modules/auth/screens/recoverPass2_screen.dart';
import 'package:provider/provider.dart';

class Recoverpass1Screen extends StatefulWidget {
  const Recoverpass1Screen({super.key});

  @override
  _Recoverpass1ScreenState createState() => _Recoverpass1ScreenState();
}

class _Recoverpass1ScreenState extends State<Recoverpass1Screen> {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _emailTouched = false;

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

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                            'Ingresa tu correo para enviar un código de recuperación.',
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
                                _emailTouched = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                _sendEmail(_emailController, context);
                              }
                            },
                            child: const Text('Enviar código',
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

void _sendEmail(dynamic emailController, BuildContext context) async {
  final dio = DioClient(context).dio;
  String email = emailController.text;

  try {
    final response = await dio.post(
      '/auth/recoverPassword',
      queryParameters: {'email': email},
    );

    print(response.data);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Revisa tu correo para obtener el código de recuperación'),
          backgroundColor: Colors.blue,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Recoverpass2Screen(email: email),
        ),
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

    errorState.showErrorDialog(context);
  }
}
