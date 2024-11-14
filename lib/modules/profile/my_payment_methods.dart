import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/payment/credit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPaymentMethods extends StatefulWidget {
  final GetPayment getPaymentMethod;
  const MyPaymentMethods({super.key, required this.getPaymentMethod});

  @override
  State<MyPaymentMethods> createState() => _MyPaymentMethodsState();
}

class _MyPaymentMethodsState extends State<MyPaymentMethods> {
  int? selectedCardIndex;

  late Future<List<PaymentCardModel>> _paymentMethodsFuture = Future.value([]);

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    setState(() {
      _paymentMethodsFuture =
          widget.getPaymentMethod.call(userId).then((paymentCards) {
        return paymentCards
            .map((paymentCard) => PaymentCardModel(
                  id: paymentCard.id,
                  userId: paymentCard.userId,
                  cardType: paymentCard.cardType,
                  cardNumber: paymentCard.cardNumber,
                  expirationDate: paymentCard.expirationDate,
                  cvv: paymentCard.cvv,
                  last4Numbers: paymentCard.last4Numbers,
                  status: paymentCard.status,
                ))
            .toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

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
      body: FutureBuilder<List<PaymentCardModel>>(
        future: _paymentMethodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los métodos de pago'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No tienes métodos de pago disponibles.'));
          }

          final paymentCards = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: paymentCards.asMap().entries.map((entry) {
                      int index = entry.key;
                      PaymentCardModel card = entry.value;

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
                            logoImage: 'assets/mlogo.png',
                            cardType: card.cardType ?? 'Crédito',
                            ownerName: card.cardNumber.isNotEmpty
                                ? '**** **** **** ${card.last4Numbers}'
                                : 'No disponible',
                            cardNumber: card.cardNumber ?? '1234567812345678',
                            expiryDate:
                                "${card.expirationDate.month.toString().padLeft(2, '0')}/${card.expirationDate.year.toString().substring(2, 4)}",
                            startColor: const Color.fromARGB(255, 95, 95, 95),
                            endColor: const Color.fromARGB(255, 186, 186, 186),
                            isSelected: selectedCardIndex == index,
                          ),
                        ),
                      );
                    }).toList(),
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
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 30, right: 20, left: 20),
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
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
