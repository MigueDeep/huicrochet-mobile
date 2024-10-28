import 'package:flutter/material.dart';

class AddadressScreen extends StatefulWidget {
  const AddadressScreen({super.key});

  @override
  _AddadressScreenState createState() => _AddadressScreenState();
}

class _AddadressScreenState extends State<AddadressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _disctrictController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  /* {
      'id': 1,
      'zipCode': '62742',
      'street': 'Privet Drive',
      'city': 'Little Whinging',
      'number': '12',
      'district': 'Surrey',
      'state': 'England',
    } */

  @override
  void initState() {
    super.initState();
    _streetController.addListener(_validateForm);
    _numberController.addListener(_validateForm);
    _cityController.addListener(_validateForm);
    _zipCodeController.addListener(_validateForm);
    _disctrictController.addListener(_validateForm);
    _stateController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _zipCodeController.dispose();
    _disctrictController.dispose();
    _stateController.dispose();
    _numberController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  bool _streetTouched = false;
  bool _numberTouched = false;
  bool _cityTouched = false;
  bool _districtTouched = false;
  bool _zipCodeTouched = false;
  bool _stateTouched = false;
  bool _isValid = false;

  String? _validateStreet(String? value) {
    if (!_streetTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa la calle';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (!_cityTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa la ciudad';
    }
    return null;
  }

  String? _validateDistrict(String? value) {
    if (!_districtTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el distrito';
    }
    return null;
  }

  String? _validateState(String? value) {
    if (!_stateTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el estado';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (!_numberTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa número de casa';
    }
    if (int.tryParse(value) == null) {
      return 'Por favor ingresa un número válido';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    if (!_zipCodeTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el código postal';
    }
    if (int.tryParse(value) == null) {
      return 'Por favor ingresa un número válido';
    }
    return null;
  }

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/addresses');
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 8),
                ListTile(
                  leading: Text('Agregar dirección',
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
                        Text('Calle:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateStreet,
                          onTap: () {
                            setState(() {
                              _streetTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Número de casa:',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color:
                                              Color.fromRGBO(130, 48, 56, 1))),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _numberController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    validator: _validateNumber,
                                    onTap: () {
                                      setState(() {
                                        _numberTouched = true;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                                width: 16), // Espaciado entre los campos
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Código postal:',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color:
                                              Color.fromRGBO(130, 48, 56, 1))),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _zipCodeController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    validator: _validateZipCode,
                                    onTap: () {
                                      setState(() {
                                        _zipCodeTouched = true;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Ciudad:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateCity,
                          onTap: () {
                            setState(() {
                              _cityTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('Distrito:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _disctrictController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateDistrict,
                          onTap: () {
                            setState(() {
                              _districtTouched = true;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('Estado:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(130, 48, 56, 1))),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _stateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: _validateState,
                          onTap: () {
                            setState(() {
                              _stateTouched = true;
                            });
                          },
                        ),
                        SizedBox(height: 40),
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
                                _streetTouched = true;
                                _numberTouched = true;
                                _cityTouched = true;
                                _districtTouched = true;
                                _zipCodeTouched = true;
                                _stateTouched = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushNamed(context, '/navigation');
                              }
                            },
                            child: const Text('Guardar',
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
