import 'package:flutter/material.dart';

Widget productCard(
    String productName, String imagePath, String price, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: GestureDetector(
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
                imagePath,
                width: 165,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              productName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Text(
              '\$' + price,
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
    ),
  );
}