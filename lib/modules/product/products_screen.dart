import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/general/category_menu.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:huicrochet_mobile/widgets/general/app_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  static const List<Map<String, String>> products = [
    {
      'name': 'Pájaro tejido a mano bala sjjsjjdjdjdjjdsj',
      'price': '99.50',
      'image': 'assets/product1.png',
    },
    {
      'name': 'Producto 2',
      'price': '79.99',
      'image': 'assets/bolsa.jpg',
      
    },
    {
      'name': 'Producto 3',
      'price': '149.99',
      'image': 'assets/snoopyAzul.jpg',
    },
    {
      'name': 'Producto 4',
      'price': '59.99',
      'image': 'assets/hellokitty.jpg',
    },
  ];

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menú de categorías
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  categoryMenu('Todas'),
                  categoryMenu('Decoración'),
                  categoryMenu('Juguetes'),
                  categoryMenu('Figuras'),
                  categoryMenu('Interiores'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Usar Expanded alrededor de GridView.builder
            Expanded(
              child: GridView.builder(
                itemCount: ProductsScreen.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final product = ProductsScreen.products[index];
                  return Center(
                    child: productCard(
                      product['name']!,
                      product['image']!,
                      product['price']!,
                      context,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
