import 'package:flutter/material.dart';

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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text(
                                          'Enviando código de recuperación'),
                                      content: LinearProgressIndicator(),
                                    );
                                  },
                                );
                                Navigator.pushNamed(context, '/recoverpass2');
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
