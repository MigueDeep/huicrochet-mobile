import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment_byId.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/update_payment.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPaymentMethod extends StatefulWidget {
  final GetPaymentByid getPaymentMethod;
  final UpdatePayment editPayment;
  final String id;
  const EditPaymentMethod(
      {super.key,
      required this.getPaymentMethod,
      required this.editPayment,
      required this.id});

  @override
  State<EditPaymentMethod> createState() => _EditPaymentMethodState();
}

class _EditPaymentMethodState extends State<EditPaymentMethod> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      _getPayment();
    });

    _NumberController.addListener(_validateForm);
    _ExpirationMonthController.addListener(_validateForm);
    _ExpirationYearController.addListener(_validateForm);
    _SecurityCodeController.addListener(_validateForm);
    _NumberController.addListener(_trackChanges);
    _ExpirationMonthController.addListener(_trackChanges);
    _ExpirationYearController.addListener(_trackChanges);
    _SecurityCodeController.addListener(_trackChanges);
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

  Future<void> _getPayment() async {
    try {
      final result = await widget.getPaymentMethod(widget.id);

      _NumberController.text = result.cardNumber;
      _ExpirationMonthController.text = result.expirationDate.month.toString();
      _ExpirationYearController.text = result.expirationDate.year.toString();
      _SecurityCodeController.text = result.cvv;
      _selectedCardType = result.cardType;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error obteniendo método de pago: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _loaderController.hide();
    }
  }

  Future<void> _updatePayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    try {
      _loaderController.show(context);

      PaymentCardModel data = PaymentCardModel(
        id: widget.id,
        userId: userId,
        cardType: _selectedCardType ?? '',
        cardNumber: _NumberController.text,
        expirationDate: DateTime(
          int.parse(_ExpirationYearController.text),
          int.parse(_ExpirationMonthController.text),
        ),
        cvv: _SecurityCodeController.text,
      );

      final result = await widget.editPayment(widget.id, data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Método de pago actualizado exitosamente."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/my-payment-methods');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error actualizando método de pago: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _loaderController.hide();
    }
  }

  bool _isChanged = false;

  void _trackChanges() {
    setState(() {
      _isChanged = _numberTouch ||
          _expirationMonthTouch ||
          _expirationYearTouch ||
          _securityCodeTouch ||
          _typeTouch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Actualizar Método de Pago',
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
                  onChanged: (value) => _trackChanges(),
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
                      _trackChanges();
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
                        onChanged: (value) => _trackChanges(),
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
                          onChanged: (value) => _trackChanges()),
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
                  onChanged: (value) => _trackChanges(),
                ),
                const SizedBox(height: 30),
                GeneralButton(
                  text: 'Actualizar',
                  onPressed: _isChanged
                      ? () {
                          setState(() {
                            _numberTouch = true;
                            _expirationMonthTouch = true;
                            _expirationYearTouch = true;
                            _securityCodeTouch = true;
                            _typeTouch = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            _updatePayment();
                          }
                        }
                      : () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
