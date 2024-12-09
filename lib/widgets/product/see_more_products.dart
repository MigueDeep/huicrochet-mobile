import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/product/providers/new_products_provider.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:huicrochet_mobile/widgets/product/product_card_loading.dart';
import 'package:provider/provider.dart';

class SeeMoreProducts extends StatefulWidget {
  const SeeMoreProducts({super.key});

  @override
  State<SeeMoreProducts> createState() => _SeeMoreProducts();
}

class _SeeMoreProducts extends State<SeeMoreProducts> {
  String searchQuery = '';
  List<Map<String, dynamic>> filteredNewProducts = [];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final newProductsProvider = Provider.of<NewProductsProvider>(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/new-products');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambien te puede interesar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
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
      const SizedBox(height: 10),
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
    ]);
  }
}
