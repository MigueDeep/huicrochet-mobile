import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/product/providers/categories_provider.dart';
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
  bool _isFirstVisit = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .fetchCategories(context);
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

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
                    categories: categoriesProvider.categories,
                    onCategorySelected: (selectedCategory) {
                      if (selectedCategory == 'Todas') {
                        setState(() {
                          productsProvider.fetchProducts(context);
                        });
                      } else {
                        final categoryId = selectedCategory;
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
                  await productsProvider.fetchProducts(context, forceRefresh: true);
                  await categoriesProvider.fetchCategories(context, forceRefresh: true);
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
