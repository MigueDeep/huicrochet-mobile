import 'package:flutter/material.dart';

Widget productCard(String productName, String? imagePath, String? price, String? id, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (id != null) {
        Navigator.pushNamed(context, '/product-detail', arguments: {'productId': id});
      }
    },
    child: Container(
      width: 165,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 165, 
              height: 170, 
              color: Colors.grey[200],
              child: Image.network(
                imagePath!,
                width: 165,
                height: 170,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/snoopyAzul.jpg', width: 155, height: 170, fit: BoxFit.cover);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            productName.length > 17 ? '${productName.substring(0, 19)}...' : productName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Text(
            '\$' + (price ?? '0'),
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
