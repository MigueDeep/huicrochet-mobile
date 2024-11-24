import 'package:flutter/material.dart' as flutter_ui;
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';

class ProductAddedToCart extends StatefulWidget {
  final String image;
  final String productName;
  final String color;
  final Color subColor;
  final int quantity;
  final double price;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const ProductAddedToCart(
      {super.key,
      required this.image,
      required this.productName,
      required this.color,
      required this.quantity,
      required this.price,
      required this.subColor,
      required this.onIncrement,
      required this.onDecrement,
      required this.onDelete});

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
                        child: flutter_ui.Image.network(
                          widget.image != null
                              ? 'http://${ip}:8080/${widget.image.split('/').last}'
                              : 'not found',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return flutter_ui.Image.asset(
                              'assets/snoopyAzul.jpg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          widget.productName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(15, 0, 0, 0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Row(
                                children: [
                                  Text(
                                    widget.color,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      color: Color.fromARGB(109, 0, 0, 0),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  CircleAvatar(
                                    backgroundColor: widget.subColor,
                                    radius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          '\$${widget.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]!)),
                            child: Center(
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 15,
                                onPressed: widget.onDecrement,
                                icon: Icon(Icons.remove),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${widget.quantity}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]!)),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 15,
                              onPressed: widget.onIncrement,
                              icon: Icon(Icons.add),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: widget.onDelete,
                          ),
                        ],
                      ),
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
