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
  List<Map<String, dynamic>> filteredProducts = [];
  String selectedCategoryReload = 'Todas';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .fetchCategories(context);
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts(context)
          .then((_) {
        setState(() {
          filteredProducts =
              Provider.of<ProductsProvider>(context, listen: false).products;
        });
      });
    });
  }

  void _filterProductsByCategory(String categoryName) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    setState(() {
      selectedCategoryReload = categoryName;
      filteredProducts = productsProvider.products.where((product) {
        final List<dynamic> productCategories = product['categoryNames'] ?? [];
        final matchesCategory =
            categoryName == 'Todas' || productCategories.contains(categoryName);
        final matchesSearchQuery = product['name']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearchQuery;
      }).toList();
    });
  }

  void _filterProductsBySearch(String query) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    setState(() {
      searchQuery = query;
      filteredProducts = productsProvider.products.where((product) {
        final List<dynamic> productCategories = product['categoryNames'] ?? [];
        final matchesCategory = selectedCategoryReload == 'Todas' ||
            productCategories.contains(selectedCategoryReload);
        final matchesSearchQuery = product['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
        return matchesCategory && matchesSearchQuery;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onSearchTextChanged: _filterProductsBySearch,
      ),
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
                      _filterProductsByCategory(selectedCategory);
                    },
                    selectedCategory: selectedCategoryReload,
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
                  await productsProvider.fetchProducts(context,
                      forceRefresh: true);
                  await categoriesProvider.fetchCategories(context,
                      forceRefresh: true);
                  setState(() {
                    _filterProductsByCategory(selectedCategoryReload);
                  });
                },
                child: productsProvider.isLoading
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
                    : filteredProducts.isEmpty
                        ? Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              Image.asset(
                                'assets/notAllowedProducts.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'Productos no encontrados',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        )
                        : GridView.builder(
                            itemCount: filteredProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
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
