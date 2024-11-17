import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/service_locator.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/payment-methods/screens/edit_payment_method.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/delete_payment.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment_byId.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/update_payment.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/payment/credit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPaymentMethods extends StatefulWidget {
  final GetPayment getPaymentMethod;
  final DeletePayment deletePaymentMethod;
  const MyPaymentMethods(
      {super.key,
      required this.getPaymentMethod,
      required this.deletePaymentMethod});

  @override
  State<MyPaymentMethods> createState() => _MyPaymentMethodsState();
}

class _MyPaymentMethodsState extends State<MyPaymentMethods> {
  int? selectedCardIndex;

  late Future<List<PaymentCardModel>> _paymentMethodsFuture;
  final LoaderController _loaderController = LoaderController();
  String? idPayment;

  @override
  void initState() {
    super.initState();
    _paymentMethodsFuture = Future.value([]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      _fetchPaymentMethods();
    });
  }

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

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar tarjeta'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar esta tarjeta de pago?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                _loaderController.show(context);
                try {
                  await widget.deletePaymentMethod(id);
                  await _fetchPaymentMethods();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tarjeta eliminada correctamente'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar la tarjeta: $e'),
                      ),
                    );
                  }
                } finally {
                  _loaderController.hide();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Métodos de pago',
          style: TextStyle(fontSize: 24),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      child: Text('No se han encontrado métodos de pago'));
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
                          cardNumber: card.cardNumber ?? '1234567812345678',
                          expiryDate:
                              "${card.expirationDate.month.toString().padLeft(2, '0')}/${card.expirationDate.year.toString().substring(2, 4)}",
                          startColor: card.cardType == 'debit'
                              ? const Color.fromARGB(255, 95, 95, 95)
                              : const Color.fromARGB(255, 0, 27, 97),
                          endColor: card.cardType == 'debit'
                              ? const Color.fromARGB(255, 186, 186, 186)
                              : const Color.fromARGB(255, 168, 193, 255),
                          isSelected: selectedCardIndex == index,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const Divider(
              thickness: 1,
              color: Color.fromARGB(63, 142, 119, 119),
            ),
            if (idPayment != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                child: GeneralButton(
                  text: 'Editar tarjeta',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPaymentMethod(
                            getPaymentMethod: getIt<GetPaymentByid>(),
                            editPayment: getIt<UpdatePayment>(),
                            id: idPayment!),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                child: GeneralButton(
                  text: 'Eliminar tarjeta',
                  onPressed: () {
                    if (selectedCardIndex != null) {
                      _showDeleteConfirmationDialog(idPayment!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona una tarjeta para eliminar'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
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
                          color: Color.fromARGB(63, 142, 119, 119), width: 0.5),
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
        ),
      ),
    );
  }
}