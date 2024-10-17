import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/category_menu.dart';
import 'package:huicrochet_mobile/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  static const List<Map<String, String>> products = [
    {
      'name': 'Pájaro tejido a mano',
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.local_shipping,
              color: Colors.black,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  hintStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Icon(
              Icons.format_bold,
              color: Colors.black,
            ),
          ],
        ),
      ),
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
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final product = ProductsScreen.products[index];  // Obtenemos el producto correspondiente
                  return Center(
                    child: productCard(
                      product['name']!, // Nombre del producto
                      product['image']!, // URL de la imagen del producto
                      product['price']!, // Precio del producto
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
