import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/modules/entities/cart.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/modules/profile/purchaseDetails.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/payment/credit_card.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/payment/purchase_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethods extends StatefulWidget {
  final Cart shoppingCart;
  final String idAddress;
  const PaymentMethods(
      {super.key,
      required this.shoppingCart,
      required this.idAddress,
      required this.getPaymentMethod});
  final GetPayment getPaymentMethod;

  get cardType => null;

  get cardNumber => null;

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  int? selectedCardIndex;

  late Future<List<PaymentCardModel>> _paymentMethodsFuture = Future.value([]);
  final LoaderController _loaderController = LoaderController();
  String? idPayment;

  Future<void> _fetchPaymentMethods() async {
    try {
      _paymentMethodsFuture = Future.value([]);
      _asingSelectedCard(null);
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';
      final paymentCards = await widget.getPaymentMethod.call(userId);
      setState(() {
        _paymentMethodsFuture = Future.value(paymentCards
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
            .toList());
      });

      _loaderController.hide();
    } catch (e) {
      print('Error fetching payment methods: $e');
      _loaderController.hide();
    } finally {
      _loaderController.hide();
    }
  }

  void _asingSelectedCard(String? id) {
    setState(() {
      idPayment = id;
    });
  }

  @override
  void initState() {
    super.initState();
    _paymentMethodsFuture = Future.value([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      _fetchPaymentMethods();
      print('direccion seleccionada: ${widget.idAddress}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PurchaseProgressBar(currentStep: 'payment'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    width: 380,
                    child: Text(
                      'Selecciona un método de pago',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<PaymentCardModel>>(
                    future: _paymentMethodsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Error al cargar los métodos de pago'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child:
                                Text('No se han encontrado métodos de pago'));
                      }
                      final paymentCards = snapshot.data!;
                      return Column(
                        children: paymentCards.map((card) {
                          int index = paymentCards.indexOf(card);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCardIndex = index;
                              });
                              _asingSelectedCard(card.id!);
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
                                cardNumber:
                                    card.cardNumber ?? '1234567812345678',
                                expiryDate:
                                    "${card.expirationDate.month.toString().padLeft(2, '0')}/${card.expirationDate.year.toString().substring(2, 4)}",
                                startColor: card.cardType == 'debit'
                                    ? colors['wine']!
                                    : const Color.fromARGB(255, 0, 27, 97),
                                endColor: card.cardType == 'debit'
                                    ? Color.fromRGBO(233, 159, 166, 0.555)
                                    : const Color.fromARGB(255, 168, 193, 255),
                                isSelected: selectedCardIndex == index,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
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
          const Divider(
            thickness: 1,
            color: Color.fromARGB(63, 142, 119, 119),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal (IVA incluido)',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '\$${widget.shoppingCart.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(20),
              child: GeneralButton(
                text: 'Continuar',
                onPressed: idPayment == null
                    ? () {}
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PurchasedetailsScreen(
                              shoppingCart: widget.shoppingCart,
                              idAddress: widget.idAddress,
                              idPayment: idPayment!,
                            ),
                          ),
                        );
                      },
              ))
        ],
      ),
    );
  }
}
