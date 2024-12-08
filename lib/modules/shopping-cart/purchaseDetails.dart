import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/config/service/notification_service.dart';
import 'package:huicrochet_mobile/config/service/websocket_service.dart';
import 'package:huicrochet_mobile/modules/entities/address.dart';
import 'package:huicrochet_mobile/modules/entities/cart.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/stripe/stripe-network.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/payment/purchase_progress_bar.dart';
import 'package:huicrochet_mobile/widgets/product/product_display_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchasedetailsScreen extends StatefulWidget {
  final Cart shoppingCart;
  final Address address;
  final PaymentCardModel payment;

  const PurchasedetailsScreen(
      {super.key,
      required this.shoppingCart,
      required this.address,
      required this.payment});

  @override
  _PurchasedetailsScreenState createState() => _PurchasedetailsScreenState();
}

class _PurchasedetailsScreenState extends State<PurchasedetailsScreen> {
  final LoaderController _loaderController = LoaderController();
  late WebSocketService _webSocketService;
  String fullName = '';
  String userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _webSocketService = WebSocketService(
      notificationService: NotificationService(),
      onPaymentSuccess: createOrder, // Callback para crear la orden.
    );

    _webSocketService.connect();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedFullName = prefs.getString('fullName') ?? '';
      setState(() {
        fullName = fetchedFullName;
        userId = prefs.getString('userId') ?? '';
      });
      _loaderController.hide();
    } catch (e) {
      print('Error fetching data: $e');
      _loaderController.hide();
    } finally {
      _loaderController.hide();
    }
  }

  Future<void> createOrder() async {
    _loaderController.show(context);
    final dio = DioClient(context).dio;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await dio.post(
        '/order',
        data: {
          'shoppingCartId': prefs.getString('shoppingCartId'),
          'shippingAddressId': widget.address.id,
          'paymentMethodId': widget.payment.id,
        },
      );

      {}
      if (response.statusCode == 200 || response.statusCode == 201) {
        _loaderController.hide();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Orden creada con éxito'),
              content: Text(
                  'Puedes ver el estado de tu pedido en la sessión de ordenes  :)'),
              actions: <Widget>[
                TextButton(
                    style:
                        TextButton.styleFrom(backgroundColor: colors['violet']),
                    onPressed: () {
                      getNewShoppingCart();
                      Navigator.pushReplacementNamed(context, '/navigation');
                    },
                    child: Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          },
        );
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

  Future<void> getNewShoppingCart() async {
    final dio = DioClient(context).dio;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('shoppingCartId');
    try {
      final response = await dio.get('/shopping-cart/user/$userId');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.data);
        final shoppingCartId = jsonData['data']['id'];
        if (shoppingCartId != null) {
          prefs.setString('shoppingCartId', shoppingCartId);
          debugPrint('Nuevo carrito: ${prefs.getString('shoppingCartId')}');
        } else {
          debugPrint('El carrito no tiene un ID válido.');
        }
      }
    } catch (e) {
      print('Error fetching shopping cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PurchaseProgressBar(currentStep: '3'),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Productos',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lista de productos
                  ...widget.shoppingCart.cartItems.map((cartItem) {
                    final product = cartItem.item.product;
                    final color = cartItem.item.color.colorName;
                    return ProductItem(
                      image: cartItem.item.images.isNotEmpty
                          ? cartItem.item.images[0].imageUri
                          : 'assets/hellokitty.jpg',
                      productName: product.productName,
                      color: color,
                      quantity: cartItem.quantity,
                      price: product.price.toDouble(),
                    );
                  }).toList(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 32, thickness: 1),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      '\$${widget.shoppingCart.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GeneralButton(
                  text: 'Confirmar y pagar',
                  onPressed: () {
                    //createOrder();
                    stripeNetwork(context, userId);
                  },
                ),
                const SizedBox(height: 5),
                const Divider(height: 32, thickness: 1),
                const SizedBox(height: 5),
                const Text(
                  'Resúmen de la orden',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      fullName,
                      style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.address.street} ${widget.address.number}, ${widget.address.district}, ${widget.address.city}, ${widget.address.state}, ${widget.address.zipCode}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Método de pago: Mastercard con terminación ${widget.payment.last4Numbers}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Por favor revise sus datos antes de confirmar',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
