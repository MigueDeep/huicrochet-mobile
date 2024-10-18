import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _emailController.text = 'ava@gmail.com';
    _nameController.text = 'Ava Johnson';
    _phoneController.text = '1234567890';
    _birthdayController.text = '01/01/1990';
    _emailController.addListener(_validateForm);
    _nameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _birthdayController.addListener(_validateForm);
    _imagePath = 'assets/logo.png';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _emailTouched = false;
  bool _nameTouched = false;
  bool _phoneTouched = false;
  bool _birthdayTouched = false;
  bool _isValid = false;

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

  String? _validatePhone(String? value) {
    if (!_phoneTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu número de teléfono';
    }
    if (value.length != 10 || int.tryParse(value) == null) {
      return 'Por favor ingresa un número de teléfono válido';
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
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
                    CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/logo.png')),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          print('Tap en el ícono de lápiz');
                          _pickImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Ava Johnson',
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
                          onTap: () {
                            setState(() {
                              _nameTouched = true;
                            });
                          },
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
                          onTap: () {
                            setState(() {
                              _emailTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Text('Teléfono:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validatePhone,
                          onTap: () {
                            setState(() {
                              _phoneTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Text('Fecha de nacimiento:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _birthdayController,
                          readOnly: true,
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
                            onPressed: () {
                              setState(() {
                                _nameTouched = true;
                                _emailTouched = true;
                                _phoneTouched = true;
                                _birthdayTouched = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text('guardando cambios'),
                                      content: LinearProgressIndicator(),
                                    );
                                  },
                                );
                                Navigator.pushNamed(context, '/profile');
                              }
                            },
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
