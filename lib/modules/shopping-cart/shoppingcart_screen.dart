import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/product/product_added_to_cart.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
class ShoppingcartScreen extends StatefulWidget {
  const ShoppingcartScreen({super.key});

  @override
  State<ShoppingcartScreen> createState() => _ShoppingcartScreenState();
}

class _ShoppingcartScreenState extends State<ShoppingcartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.shopping_cart,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Carrito de compras',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
                  ProductAddedToCart(
                    image: 'assets/hellokitty.jpg',
                    productName: 'Hello Kitty Plush',
                    color: 'Rosa',
                    quantity: 1,
                    price: 99.99,
                    subColor: Colors.pink,
                  ),
                  ProductAddedToCart(
                    image: 'assets/sueterazul.jpg',
                    productName: 'Sueter tejido a mano',
                    color: 'Azul',
                    quantity: 3,
                    price: 189,
                    subColor: Colors.blue,
                  ),
                  ProductAddedToCart(
                    image: 'assets/snoopyAzul.jpg',
                    productName: 'Snoopy',
                    color: 'Azul',
                    quantity: 1,
                    price: 116.53,
                    subColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Subtotal (IVA incluido)',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '\$99.50',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GeneralButton(
              text: 'Continuar al pago',
              onPressed: () {
                Navigator.pushNamed(context, '/mailing-address');
              },
            ),
          ),
        ],
      ),
    );
  }
}
