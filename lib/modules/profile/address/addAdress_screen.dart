import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController _phoneNumberController = TextEditingController();
  final LoaderController _loaderController = LoaderController();

  @override
  void initState() {
    super.initState();
    _streetController.addListener(_validateForm);
    _numberController.addListener(_validateForm);
    _cityController.addListener(_validateForm);
    _zipCodeController.addListener(_validateForm);
    _disctrictController.addListener(_validateForm);
    _stateController.addListener(_validateForm);
    _phoneNumberController.addListener(_validateForm);
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
  bool _phoneNumberTouched = false;
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

  String? _validatePhoneNumber(String? value) {
    if (!_phoneNumberTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa número de teléfono';
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

  Future<void> createAddress() async {
    _loaderController.show(context);
    final dio = DioClient(context).dio;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await dio.post(
        '/shipping-address',
        data: {
          'userId': prefs.getString('userId'),
          'state': _stateController.text,
          'city': _cityController.text,
          'zipCode': _zipCodeController.text,
          'district': _disctrictController.text,
          'street': _streetController.text,
          'number': _numberController.text,
          'phoneNumber': _phoneNumberController.text,
          'defaultAddress': false,
          'status': true
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _loaderController.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dirección de envío registrada'),
            backgroundColor: Colors.blue,
          ),
        );
        Navigator.pushReplacementNamed(context, '/addresses');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Agregar dirección de envío',
            style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
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
                Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calle:',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'Privete Drive',
                            prefixIcon: Icon(Icons.streetview),
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
                                          color: colors['wine'])),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _numberController,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      hintText: '24',
                                      prefixIcon: Icon(Icons.house),
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
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Código postal:',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: colors['wine'])),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _zipCodeController,
                                    maxLength: 5,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      hintText: '12345',
                                      prefixIcon: Icon(Icons.location_city),
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
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'Londres',
                            prefixIcon: Icon(Icons.location_city),
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
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _disctrictController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'Privet',
                            prefixIcon: Icon(Icons.location_city),
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
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _stateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'Little Whinging',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          validator: _validateState,
                          onTap: () {
                            setState(() {
                              _stateTouched = true;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        Text('Número de teléfono de quien recibe:',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: colors['wine'])),
                        const SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phoneNumberController,
                          maxLength: 10,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: '1234567890',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: _validatePhoneNumber,
                          onTap: () {
                            setState(() {
                              _phoneNumberTouched = true;
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
                              backgroundColor: colors['violet'],
                            ),
                            onPressed: () {
                              setState(() {
                                _phoneNumberTouched = true;
                                _streetTouched = true;
                                _numberTouched = true;
                                _cityTouched = true;
                                _districtTouched = true;
                                _zipCodeTouched = true;
                                _stateTouched = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                createAddress();
                              }
                            },
                            child: const Text('Registrar dirección',
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
