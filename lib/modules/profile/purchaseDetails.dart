import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/entities/address.dart';
import 'package:huicrochet_mobile/modules/entities/cart.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/payment/purchase_progress_bar.dart';
import 'package:huicrochet_mobile/widgets/product/product_display_widget.dart';
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
  String fullName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString('fullName') ?? '';
    try {
      final userId = prefs.getString('userId') ?? '';

      _loaderController.hide();
    } catch (e) {
      print('Error fetching data: $e');
      _loaderController.hide();
    } finally {
      _loaderController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PurchaseProgressBar(currentStep: '3'),
      body: Column(
        children: [
          // Sección de productos
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  // Lista dinámica de productos
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 32, thickness: 1),
                const SizedBox(height: 16),
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
                    print('Confirmar y pagar');
                  },
                ),
                const SizedBox(height: 5),
                const Divider(height: 32, thickness: 1),
                const SizedBox(height: 16),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
