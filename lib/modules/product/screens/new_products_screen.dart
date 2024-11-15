import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/product/providers/produc_provider.dart';
import 'package:huicrochet_mobile/widgets/general/app_bar.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProductsScreen extends StatefulWidget {
  @override
  _NewProductsScreenState createState() => _NewProductsScreenState();
}

class _NewProductsScreenState extends State<NewProductsScreen> {
  bool _isFirstVisit = true;

  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasVisited = prefs.getBool('hasVisitedNewProducts') ?? false;
    setState(() {
      _isFirstVisit = !hasVisited;
    });
    if (_isFirstVisit) {
      await prefs.setBool('hasVisitedNewProducts', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    if (_isFirstVisit) {
      productsProvider.fetchProducts(context, endpoint: '/product/getTop10');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              'Nuevos Productos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 40), 
            child: RefreshIndicator(
              backgroundColor: Colors.white,
                color: const Color.fromRGBO(242, 148, 165, 1),
              onRefresh: () async {
                await productsProvider.fetchProducts(context, forceRefresh: true, endpoint: '/product/getTop10');
              },
              child: productsProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: GridView.builder(
                        itemCount: productsProvider.products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final product = productsProvider.products[index];
                          return productCard(
                            product['name'] as String,
                            product['imageUri'] as String,
                            product['price'].toString(),
                            product['productId'].toString(),
                            context,
                          );
                        },
                      ),
                    ),
            ),
          ),
          
          // Botón de retroceso en la parte inferior
          Positioned(
            bottom: 30,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 207, 82, 151),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.only(right: 1),
                fixedSize: const Size(60, 60),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
