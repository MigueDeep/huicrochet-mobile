import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/modules/auth/screens/recoverPass3_screen.dart';
import 'package:provider/provider.dart';

class Recoverpass2Screen extends StatefulWidget {
  const Recoverpass2Screen({super.key, required this.email});
  final String email;

  @override
  _Recoverpass2ScreenState createState() => _Recoverpass2ScreenState();
}

class _Recoverpass2ScreenState extends State<Recoverpass2Screen> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _nameTouched = false;

  String? _validateName(String? value) {
    if (!_nameTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el código de recuperación';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _codeController.dispose();
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
                  Text(
                    'HUICROCHET',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors['wine'],
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
                              color: colors['wine'],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ingresa el código de recuperación que te enviamos a tu correo electrónico',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors['wine'],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: 'Código de recuperación',
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
                            onPressed: () {
                              setState(() {
                                _nameTouched = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                _verifyCode(_codeController.text, context);
                              }
                            },
                            child: const Text('Validar código',
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

  void _verifyCode(String code, BuildContext context) async {
    print('Si no sales, hazme una llamada y yo cambio los planes: ');
    print(widget.email);
    print(code);
    final dio = DioClient(context).dio;

    try {
      final response = await dio.post(
        '/auth/validateToken',
        queryParameters: {'email': widget.email, 'token': code},
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recoverpass3Screen(
              email: widget.email,
              code: code,
            ),
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
}
