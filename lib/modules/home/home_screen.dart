import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:huicrochet_mobile/widgets/general/app_bar.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/banner.png',
                        width: 380,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 380,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    Positioned(
                      bottom: 140,
                      left: 15,
                      child: Text(
                        'ARTE EN CADA PUNTADA',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 110,
                      left: 15,
                      child: Text(
                        'CALIDAD EN CADA DETALLE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/products');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nuevos productos',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       children: ProductsScreen.products.map((product) {
              //         return productCard(
              //           product['name']!, // Nombre del producto
              //           product['image']!, // URL de la imagen del producto
              //           product['price']!, 
              //           product['id']!,// Precio del producto
              //           context,
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/products');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Más vendidos',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       children: ProductsScreen.products.map((product) {
              //         return productCard(
              //           product['name']!, // Nombre del producto
              //           product['image']!, // URL de la imagen del producto
              //           product['price']!,
              //           product['id']!, // Precio del producto
              //           context,
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}