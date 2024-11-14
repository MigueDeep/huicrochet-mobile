import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/modules/product/entities/product_category.dart';
import 'package:huicrochet_mobile/modules/product/use_cases/fetch_products_data.dart';
import 'package:huicrochet_mobile/widgets/general/category_menu.dart';
import 'package:huicrochet_mobile/widgets/product/product_card.dart';
import 'package:huicrochet_mobile/widgets/general/app_bar.dart';

class ProductsScreen extends StatefulWidget {
  final FetchProductsData getProductsUseCase;

  const ProductsScreen({super.key, required this.getProductsUseCase});

  static const List<Map<String, String>> products = [
    {
      'name': 'Pájaro tejido a mano bala sjjsjjdjdjdjjdsj',
      'price': '99.50',
    },
    {
      'name': 'Producto 2',
      'price': '79.99',
      'image': 'assets/bolsa.jpg',
    },
    {
      'name': 'Producto 3',
      'price': '149.99',
      'image': 'assets/snoopyAzul.jpg',
    },
    {
      'name': 'Producto 4',
      'price': '59.99',
      'image': 'assets/hellokitty.jpg',
    },
  ];

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<String> categories = ['Todas'];
  // List<Product> products = response.map((productData) {
  //   return Product(
  //     productName: productData['name'],
  //     price: productData['price'],
  //     image: productData['image'],
  //   );
  // }).toList();

  @override
  void initState() {
    super.initState();
    _getCategories();
    // _fetchProducts();
  }

  // Future<void> _fetchProducts() async {
  //   try {
  //     final response = await widget.getProductsUseCase.execute();

  //     setState(() {
  //       products = response;
  //       print(products);
  //     });
  //   } catch (e) {
  //     print('Error fetching products: $e');
  //   }
  // }

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
    } on DioException catch (e) {
      String errorMessage = 'Error al obtener categorías';
      if (e.response != null && e.response?.data != null) {
        try {
          final errorData = jsonDecode(e.response!.data);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {
          errorMessage = e.message ?? 'Error desconocido';
        }
      }
      print('Error de red ${errorMessage}');
    } catch (e) {
      print('Error desconocido ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menú de categorías
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                CategoryMenu(
                  categories: categories,
                  onCategorySelected: (selectedCategory) {},
                )
              ]),
            ),
            const SizedBox(height: 10),
            // Expanded(
            //   child: GridView.builder(
            //     itemCount: products.length,
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       childAspectRatio: 0.8,
            //     ),
            //     itemBuilder: (context, index) {
            //       final product = products[index]; // Obtener un producto
            //       return productCard(
            //           product, context); // Pasar el producto y el contexto
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
