import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/product/providers/new_products_provider.dart';
import 'package:huicrochet_mobile/widgets/general/app_bar.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:huicrochet_mobile/widgets/product/product_card_loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    if (_isFirstVisit) {
      newProductsProvider.fetchNewProducts(context);
    }

    return Scaffold(
      appBar: CustomAppBar(
        onSearchTextChanged: _filterNewProducts,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
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
        child: SingleChildScrollView(
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
                        Navigator.pushNamed(context, '/new-products');
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: newProductsProvider.isLoading
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              6,
                              (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: loadingProductCard()),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: filteredNewProducts.map((product) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: productCard(
                                  product['name'] as String,
                                  product['imageUri'] as String,
                                  product['price'].toString(),
                                  product['productId'].toString(),
                                  context,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/new-products');
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: newProductsProvider.isLoading
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              6,
                              (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: loadingProductCard()),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: filteredNewProducts.map((product) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: productCard(
                                  product['name'] as String,
                                  product['imageUri'] as String,
                                  product['price'].toString(),
                                  product['productId'].toString(),
                                  context,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
