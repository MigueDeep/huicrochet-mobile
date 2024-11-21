import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/general/app_bar.dart';
import 'package:huicrochet_mobile/widgets/general/category_menu.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:huicrochet_mobile/widgets/product/product_card_loading.dart';
import 'package:provider/provider.dart';
import 'package:huicrochet_mobile/modules/product/providers/produc_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<String> categories = ['Todas'];
   List<Map<String, dynamic>> productsByCategory = [];
   Map<String, String> categoryIdMap = {};
  bool _isFirstVisit = true;

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _getCategories() async {
    final dioClient = DioClient(context);

    try {
      final response = await dioClient.dio.get('/category/getAllTrue');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.toString());
        final List<dynamic> categoryData = jsonData['data'];

        setState(() {
          categories = ['Todas'];
          categories.addAll(
            categoryData.map((category) => category['name'] as String).toList(),
          );
        });
      } else {
        print('Error al obtener categorías ${response.statusCode}');
      }
    } catch (e) {
      print('Error desconocido ${e.toString()}');
    }
  }

// Future<void> _getProductsByCategory(String categoryId) async {
//     final dioClient = DioClient(context);

//     try {
//       print(''+categoryId);
//       final response = await dioClient.dio.get('/product/getByCategory/$categoryId');

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.toString());
//         final List<dynamic> productData = jsonData['data'];

//         setState(() {
//           productsByCategory =
//               productData.map((product) => product['name'] as String).cast<Map<String, dynamic>>().toList();
//         });
//       } else {
//         print('Error al obtener productos: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error desconocido: ${e.toString()}');
//     }
//   }



  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    if (_isFirstVisit) {
      productsProvider.fetchProducts(context);
      setState(() {
        _isFirstVisit = false;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                   CategoryMenu(
                    categories: categories,
                    onCategorySelected: (selectedCategory) {
                      final categoryId = categoryIdMap[selectedCategory] ?? '';
                      if (selectedCategory == 'Todas') {
                        setState(() {
                          productsByCategory = [];
                        });
                      } else {
                       // _getProductsByCategory(categoryId);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                color: const Color.fromRGBO(242, 148, 165, 1),
                onRefresh: () async {
                  await productsProvider.fetchProducts(
                    context,
                    forceRefresh: true
                  );
                },
                child: productsProvider.isLoading
                    ? GridView.builder(
                        itemCount: 6,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          return Center(
                            child: loadingProductCard(), 
                          );
                        },
                      )
                    : GridView.builder(
                        itemCount: productsProvider.products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final product = productsProvider.products[index];
                          return Center(
                            child: productCard(
                              product['name'] as String,
                              product['imageUri'] as String,
                              product['price'].toString(),
                              product['productId'].toString(),
                              context,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}