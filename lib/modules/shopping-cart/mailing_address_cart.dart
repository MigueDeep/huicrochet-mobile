import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/modules/entities/address.dart';
import 'package:huicrochet_mobile/modules/entities/cart.dart';
import 'package:huicrochet_mobile/modules/entities/user.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/payment_methods.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/payment/purchase_progress_bar.dart';
import 'package:huicrochet_mobile/widgets/payment/select_address_card.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailingAddressCart extends StatefulWidget {
  final Cart shoppingCart;
  const MailingAddressCart(
      {super.key, required this.shoppingCart, required this.getPaymentMethod});
  final GetPayment getPaymentMethod;

  @override
  State<MailingAddressCart> createState() => _MailingAddressCartState();
}

class _MailingAddressCartState extends State<MailingAddressCart> {
  List<Address> addresses = [];
  bool content = false;
  final LoaderController _loaderController = LoaderController();
  Future<void> getShippingAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;

    try {
      final response =
          await dio.get('/shipping-address/user/${prefs.getString('userId')}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.data);
        setState(() {
          try {
            final dataList = jsonData['data'] as List;
            addresses = dataList.map((address) {
              final userMap = address['user'] ?? {};

              return Address(
                address['id']?.toString() ?? '',
                address['state']?.toString() ?? 'Desconocido',
                address['city']?.toString() ?? 'Desconocida',
                address['zipCode']?.toString() ?? '',
                address['district']?.toString() ?? '',
                address['street']?.toString() ?? '',
                address['number']?.toString() ?? '',
                address['phoneNumber']?.toString() ?? '',
                address['defaultAddress'] == true,
                address['status'] == true,
                User(
                  userMap['id']?.toString() ?? '',
                  userMap['fullName']?.toString() ?? 'Sin nombre',
                  userMap['email']?.toString() ?? 'Sin email',
                  DateTime.tryParse(userMap['birthday']?.toString() ?? '') ??
                      DateTime.now(),
                  userMap['status'] == true,
                  userMap['blocked'] == true,
                  userMap['image']?.toString(),
                ),
              );
            }).toList();
            _loaderController.hide();
            content = false;
          } catch (e) {
            print('Error específico al mapear los datos: $e');
            final errorState = Provider.of<ErrorState>(context, listen: false);
            errorState.setError('Error al procesar las direcciones.');
            errorState.showErrorDialog(context);
            setState(() {
              _loaderController.hide();
            });
          }
        });
      } else if (response.statusCode == 204) {
        setState(() {
          content = true;
          _loaderController.hide();
        });
      }
    } catch (e) {
      print('Error al obtener las direcciones: $e');
      final errorState = Provider.of<ErrorState>(context, listen: false);
      errorState.setError(e is DioException && e.response?.statusCode == 400
          ? e.response?.data['message'] ?? 'Error desconocido'
          : 'Error de conexión');
      errorState.showErrorDialog(context);
      setState(() {
        _loaderController.hide();
        content = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      getShippingAddresses();
    });
  }

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
                    Address address = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SelectAddressCard(
                        name: '${address.street} ${address.number}',
                        address:
                            '${address.district}, ${address.city}, ${address.state}',
                        isSelected: _selectedIndex == index ||
                            entry.value.defaultAddress,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            addresses = addresses.map((address) {
                              address.defaultAddress = false;
                              return address;
                            }).toList();
                            addresses[index].defaultAddress = true;
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/addAddress');
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
                  Text(
                    'Subtotal (IVA incluido)',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '\$${widget.shoppingCart.total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(20),
              child: GeneralButton(
                text: 'Continuar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethods(
                        shoppingCart: widget.shoppingCart,
                        idAddress: _selectedIndex >= 0
                            ? addresses[_selectedIndex].id!
                            : addresses
                                .firstWhere((address) => address.defaultAddress)
                                .id!,
                        getPaymentMethod: widget.getPaymentMethod,
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
