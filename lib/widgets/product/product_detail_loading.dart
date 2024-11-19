import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailLoading extends StatelessWidget {
  const ProductDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 320,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 200,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 280,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
