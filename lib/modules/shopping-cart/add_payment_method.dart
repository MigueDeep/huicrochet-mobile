import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/general_button.dart';
import 'package:huicrochet_mobile/widgets/general_input.dart';
import 'package:huicrochet_mobile/widgets/payment/date_input.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Form(
        child: Column(children: [
          SizedBox(height: 8),
          ListTile(
            leading: Text('Agregar nuevo método de pago',
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
                GeneralInput(
                  label: 'Número de tarjeta:',
                  inputType: TextInputType.number,
                  controller: TextEditingController(),
                  maxLength: 16,
                  isNumeric: true,
                ),
                const SizedBox(height: 16),
                GeneralInput(
                  label: 'Nombre del propietario:',
                  inputType: TextInputType.number,
                  controller: TextEditingController(),
                  isAlphabetic: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateInput(
                            label: 'Fecha de vencimiento:',
                            controller: TextEditingController(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GeneralInput(
                            label: 'CVV:',
                            inputType: TextInputType.number,
                            controller: TextEditingController(),
                            maxLength: 3,
                            isNumeric: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: GeneralButton(
                      text: 'Guardar',
                      onPressed: () {},
                    ))
              ],
            ),
          )
        ]),
      )),
    );
  }
}
