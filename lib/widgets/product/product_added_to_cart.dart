import 'package:flutter/material.dart';

class ProductAddedToCart extends StatefulWidget {
  final String image;
  final String productName;
  final String color;
  final Color subColor;
  final int quantity;
  final double price;

  const ProductAddedToCart(
      {super.key,
      required this.image,
      required this.productName,
      required this.color,
      required this.quantity,
      required this.price,
      required this.subColor});

  @override
  State<ProductAddedToCart> createState() => _ProductAddedToCartState();
}

class _ProductAddedToCartState extends State<ProductAddedToCart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          widget.image,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.delete_outline),
                          ],
                        ),
                         Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                          child: Text(
                            widget.productName,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),)
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.color,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      CircleAvatar(
                        backgroundColor: widget.subColor,
                        radius: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '|',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        'x${widget.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${widget.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
