import 'package:flutter/material.dart';
class CreditCard extends StatelessWidget {
  final String logoImage;
  final String cardType;
  final String ownerName;
  final String cardNumber;
  final String expiryDate;
  final Color startColor;
  final Color endColor;
  final bool isSelected; 

  const CreditCard({
    super.key,
    required this.logoImage,
    required this.cardType,
    required this.ownerName,
    required this.cardNumber,
    required this.expiryDate,
    required this.startColor,
    required this.endColor,
    this.isSelected = false,
  });

  String getMaskedCardNumber() {
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: isSelected
            ? Border.all(color: const Color.fromRGBO(242, 148, 165, 1), width: 5) 
            : null,
      
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardType.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  logoImage,
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            getMaskedCardNumber(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ownerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                expiryDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
