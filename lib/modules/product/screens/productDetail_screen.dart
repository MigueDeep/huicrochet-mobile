import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/product/entities/product_category.dart';
import 'package:huicrochet_mobile/modules/product/providers/product_details_provider.dart';
import 'package:huicrochet_mobile/widgets/product/product_detail_loading.dart';
import 'package:huicrochet_mobile/widgets/product/select_colors.dart';
import 'package:huicrochet_mobile/widgets/product/user_comment.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' as flutter_ui;

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (args != null) {
      final productId = args['productId'] ?? '';
      // Llamar la función de fetchProductDetails solo una vez cuando el ID cambia
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .fetchProductDetails(context, id: productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.products.isEmpty) {
          return Center(child: Text('No se encontraron productos.'));
        }

        var productData = provider.products[0];

        return Center(
          child: Column(
            children: [
              Text(productData['name']),  // Mostrar el nombre del producto
              Text(productData['price']), // Mostrar el precio del producto
              // Mostrar todas las imágenes
              Expanded(
                child: ListView.builder(
                  itemCount: productData['imageUris'].length,
                  itemBuilder: (context, index) {
                    var imageUri = productData['imageUris'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          imageUri,
                          width: 320,
                          height: 400,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/snoopyAzul.jpg',
                              width: 320,
                              height: 400,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Mostrar categorías
              Text('Categorías:'),
              for (var category in productData['categoryNames'])
                Text(' - $category'),

              // Mostrar color
              Text('Color: ${productData['color']}'),
            ],
          ),
        );
      },
    );
  }
}
