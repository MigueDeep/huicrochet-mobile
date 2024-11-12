import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/payment/credit_card.dart';
import 'package:huicrochet_mobile/widgets/payment/purchase_progress_bar.dart';

class MyPaymentMethods extends StatefulWidget {
  const MyPaymentMethods({super.key});

  @override
  State<MyPaymentMethods> createState() => _MyPaymentMethodsState();
}

class _MyPaymentMethodsState extends State<MyPaymentMethods> {
  int? selectedCardIndex;

  final List<Map<String, dynamic>> cards = [
    {
      'logoImage': 'assets/mlogo.png',
      'cardType': 'Crédito',
      'ownerName': 'Juan Pérez',
      'cardNumber': '1234567812345678',
      'expiryDate': '12/25',
      'startColor': const Color.fromARGB(255, 95, 95, 95),
      'endColor': const Color.fromARGB(255, 186, 186, 186),
    },
    {
      'logoImage': 'assets/vlogo.png',
      'cardType': 'Débito',
      'ownerName': 'Ana García',
      'cardNumber': '8765432187654321',
      'expiryDate': '11/24',
      'startColor': const Color.fromARGB(255, 0, 27, 97),
      'endColor': const Color.fromARGB(255, 168, 193, 255),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Métodos de pago',
          style: TextStyle(
            fontSize: 24,
          ),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Generar tarjetas desde la lista
                  ...cards.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> card = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCardIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: CreditCard(
                          logoImage: card['logoImage'],
                          cardType: card['cardType'],
                          ownerName: card['ownerName'],
                          cardNumber: card['cardNumber'],
                          expiryDate: card['expiryDate'],
                          startColor: card['startColor'],
                          endColor: card['endColor'],
                          isSelected: selectedCardIndex == index,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            color: Color.fromARGB(63, 142, 119, 119),
          ),
          Padding(
           padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
              child: GeneralButton(
                  text: 'Editar tarjeta',
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-payment-method');
                  })),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30, right: 20, left: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                            color: Color.fromARGB(63, 142, 119, 119),
                            width: 0.5),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Agregar tarjeta',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/add-payment-method');
                    }),
              )),
        ],
      ),
    );
  }
}
