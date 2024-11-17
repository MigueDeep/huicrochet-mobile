import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/create_payment.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/payment/credit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPaymentMethod extends StatefulWidget {
  final CreatePayment createPayment;
  const AddPaymentMethod({super.key, required this.createPayment});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  final TextEditingController _NumberController = TextEditingController();
  final TextEditingController _ExpirationMonthController =
      TextEditingController();
  final TextEditingController _ExpirationYearController =
      TextEditingController();
  final TextEditingController _SecurityCodeController = TextEditingController();
  final LoaderController _loaderController = LoaderController();
  var _numberTouch = false;
  var _expirationMonthTouch = false;
  var _expirationYearTouch = false;
  var _securityCodeTouch = false;
  var _typeTouch = false;
  var _isValid = false;

  final _formKey = GlobalKey<FormState>();

  // Dropdown value
  String? _selectedCardType;

  @override
  void initState() {
    super.initState();
    _NumberController.addListener(_validateForm);
    _ExpirationMonthController.addListener(_validateForm);
    _ExpirationYearController.addListener(_validateForm);
    _SecurityCodeController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _NumberController.dispose();
    _ExpirationMonthController.dispose();
    _ExpirationYearController.dispose();
    _SecurityCodeController.dispose();

    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  String? _validateNumber(String? value) {
    if (!_numberTouch) {
      return null;
    }

    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese el número de tarjeta';
    }
    if (value.length != 16) {
      return 'El número de tarjeta debe tener 16 dígitos';
    }
    return null;
  }

  String? _validateExpirationMonth(String? value) {
    if (!_expirationMonthTouch) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese el mes de vencimiento';
    }
    if (int.tryParse(value) == null ||
        int.parse(value) < 1 ||
        int.parse(value) > 12) {
      return 'Ingrese un mes válido (1-12)';
    }
    return null;
  }

  String? _validateExpirationYear(String? value) {
    if (!_expirationYearTouch) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese el año de vencimiento';
    }
    if (value.length != 4) {
      return 'El año de vencimiento debe tener 4 dígitos';
    }
    if (int.parse(value) < DateTime.now().year) {
      return 'El año no puede ser menor al actual';
    }
    return null;
  }

  String? _validateSecurityCode(String? value) {
    if (!_securityCodeTouch) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese el código de seguridad';
    }
    if (value.length != 3) {
      return 'El código debe tener 3 dígitos';
    }
    return null;
  }

  Future<void> _createPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    try {
      _loaderController.show(context);

      PaymentCardModel data = PaymentCardModel(
        userId: userId,
        cardType: _selectedCardType ?? '',
        cardNumber: _NumberController.text,
        expirationDate: DateTime(
          int.parse(_ExpirationYearController.text),
          int.parse(_ExpirationMonthController.text),
        ),
        cvv: _SecurityCodeController.text,
        last4Numbers:
            _NumberController.text.substring(_NumberController.text.length - 4),
      );

      final result = await widget.createPayment(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Método de pago creado exitosamente."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/my-payment-methods');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creando método de pago: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _loaderController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agregar Método de Pago',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _NumberController,
                  decoration: InputDecoration(
                    labelText: 'Número de tarjeta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  maxLength: 16,
                  onTap: () {
                    setState(() {
                      _numberTouch = true;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCardType,
                  decoration: InputDecoration(
                    labelText: 'Tipo de tarjeta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'credit', child: Text('Crédito')),
                    DropdownMenuItem(value: 'debit', child: Text('Débito')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCardType = value;
                    });
                  },
                  validator: (value) => _typeTouch && value == null
                      ? 'Seleccione el tipo de tarjeta'
                      : null,
                  onTap: () {
                    setState(() {
                      _typeTouch = true;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 2,
                        controller: _ExpirationMonthController,
                        decoration: InputDecoration(
                          labelText: 'Mes de vencimiento',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateExpirationMonth,
                        onTap: () {
                          setState(() {
                            _expirationMonthTouch = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        maxLength: 4,
                        controller: _ExpirationYearController,
                        decoration: InputDecoration(
                          labelText: 'Año de vencimiento',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateExpirationYear,
                        onTap: () {
                          setState(() {
                            _expirationYearTouch = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _SecurityCodeController,
                  decoration: InputDecoration(
                    labelText: 'Código de seguridad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateSecurityCode,
                  maxLength: 3,
                  onTap: () {
                    setState(() {
                      _securityCodeTouch = true;
                    });
                  },
                ),
                const SizedBox(height: 20),
                CreditCard(
                  logoImage: 'assets/mlogo.png',
                  cardType: _selectedCardType ?? 'Crédito',
                  ownerName: 'Usuario',
                  cardNumber: _NumberController.text.length == 16
                      ? '**** **** **** ${_NumberController.text.substring(_NumberController.text.length - 4)}'
                      : '**** **** **** 0000',
                  expiryDate: _ExpirationMonthController.text.isNotEmpty &&
                          _ExpirationYearController.text.length == 4
                      ? "${_ExpirationMonthController.text.padLeft(2, '0')}/${_ExpirationYearController.text.length >= 4 ? _ExpirationYearController.text.substring(2, 4) : '00'}"
                      : '01/00',
                  startColor: _selectedCardType == 'Crédito'
                      ? const Color.fromARGB(255, 95, 95, 95)
                      : const Color.fromARGB(255, 0, 27, 97),
                  endColor: _selectedCardType == 'Crédito'
                      ? const Color.fromARGB(255, 186, 186, 186)
                      : const Color.fromARGB(255, 168, 193, 255),
                  isSelected: false,
                ),
                const SizedBox(height: 30),
                GeneralButton(
                  text: 'Guardar',
                  onPressed: () {
                    setState(() {
                      _numberTouch = true;
                      _expirationMonthTouch = true;
                      _expirationYearTouch = true;
                      _securityCodeTouch = true;
                      _typeTouch = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      _createPayment();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
