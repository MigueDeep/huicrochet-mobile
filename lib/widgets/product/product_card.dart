import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/product/entities/product_category.dart';

Widget productCard(Product product, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/product-detail');
    },
    child: Container(
      width: 165,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
               'assets/logo.png', // Cambia esta línea para usar la imagen del producto
              width: 155,
              height: 170,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.productName ?? 'Nombre producto', // Cambia esta línea para usar el nombre del producto
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Text(
            product.price.toString() ?? 'Precio', // Cambia esta línea para usar el precio del producto
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
