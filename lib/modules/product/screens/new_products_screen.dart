import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/product/providers/new_products_provider.dart'; 
import 'package:huicrochet_mobile/widgets/general/app_bar.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:huicrochet_mobile/widgets/product/product_card_loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProductsScreen extends StatefulWidget {
  @override
  _NewProductsScreenState createState() => _NewProductsScreenState();
}
class _NewProductsScreenState extends State<NewProductsScreen> {
  bool _isFirstVisit = true;
  String searchQuery = '';
  List<Map<String, dynamic>> filteredNewProducts = [];

  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newProductsProvider =
          Provider.of<NewProductsProvider>(context, listen: false);
      newProductsProvider.fetchNewProducts(context).then((_) {
        setState(() {
          filteredNewProducts = newProductsProvider.newProducts;
        });
      });
    });
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

  void _filterNewProducts(String query) {
    final newProductsProvider =
        Provider.of<NewProductsProvider>(context, listen: false);

    setState(() {
      searchQuery = query;
      filteredNewProducts = newProductsProvider.newProducts.where((product) {
        final productName = product['name']?.toLowerCase() ?? '';
        return productName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newProductsProvider = Provider.of<NewProductsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onSearchTextChanged: _filterNewProducts,
      ),
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
                await newProductsProvider.fetchNewProducts(context,
                    forceRefresh: true);
                setState(() {
                  filteredNewProducts = newProductsProvider.newProducts;
                  _filterNewProducts(searchQuery);
                });
              },
              child: newProductsProvider.isLoading
                  ? GridView.builder(
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        return Center(
                          child: loadingProductCard(),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: GridView.builder(
                        itemCount: filteredNewProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredNewProducts[index];
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
