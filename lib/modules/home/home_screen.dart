import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _categoryItem('Todas'),
              _categoryItem('Decoración'),
              _categoryItem('Juguetes'),
              _categoryItem('Figuras'),
              _categoryItem('Interiores'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
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
                  'CALIDAD EN CADA DETALLE.',
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Nuevos productos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _productCard('Producto 1', 'assets/product1.png', '99.50'),
                _productCard('Producto 2', 'assets/product1.png', '99.50'),
                _productCard('Producto 3', 'assets/product1.png', '99.50'),
                _productCard('Producto 4', 'assets/product1.png', '99.50'),
              ],
            ),
          ),
        ),
      ])),
    );
  }
}

Widget _categoryItem(String categoryName) {
  bool isSelected = categoryName == 'Todas';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _productCard(String productName, String imagePath, String price) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
      width: 150,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 150,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            productName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Text(
            '\$$price',
            style: TextStyle(
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
