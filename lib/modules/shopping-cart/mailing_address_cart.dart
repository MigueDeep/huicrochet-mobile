import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/payment/purchase_progress_bar.dart';
import 'package:huicrochet_mobile/widgets/payment/select_address_card.dart';
import 'package:huicrochet_mobile/widgets/general_button.dart';

class MailingAddressCart extends StatefulWidget {
  const MailingAddressCart({super.key});

  @override
  State<MailingAddressCart> createState() => _MailingAddressCartState();
}

class _MailingAddressCartState extends State<MailingAddressCart> {
  final List<Map<String, String>> addresses = const [
    {'name': 'Juan Pérez', 'address': 'Calle Falsa 123, Ciudad '},
    {
      'name': 'Ana López',
      'address': 'Av. Real 456, Ciudad Calle Falsa 123, Ciudad'
    },
    {'name': 'Carlos García', 'address': 'Boulevard Central 789, Ciudad'},
    {'name': 'Juan Pérez', 'address': 'Calle Falsa 123, Ciudad '},
    {
      'name': 'Ana López',
      'address': 'Av. Real 456, Ciudad Calle Falsa 123, Ciudad'
    },
    {'name': 'Carlos García', 'address': 'Boulevard Central 789, Ciudad'}
    
  ];
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PurchaseProgressBar(currentStep: '1'),
      body: Column(
        children: [
          Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
            width: 380,
            child: Text(
              'Selecciona una dirección de envío',
              style: TextStyle(
                fontSize: 24,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
                ...addresses.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, String> address = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SelectAddressCard(
                      name: address['name']!,
                      address: address['address']!,
                      isSelected: _selectedIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                          color: Color.fromARGB(63, 142, 119, 119),
                          width: 0.5), // Borde negro
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'Agregar direccion',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/addAddress');
                  }
                ),
              )),
          const Divider(
            thickness: 1,
            color: Color.fromARGB(63, 142, 119, 119),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal (IVA incluido)',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '\$99.50',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(20),
              child: GeneralButton(
                text: 'Continuar',
                onPressed: () {
                  Navigator.pushNamed(context, '/payment-methods');
                },
              ))
        ],
      ),
    );
  }
}
