import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';

class ProductDetailsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _productItems = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get products => _productItems;

  Future<void> fetchProductDetails(
    BuildContext context, {
    bool forceRefresh = false,
    String endpoint = "/item/getItemsByProductId/",
    required String id,
  }) async {
    if (_productItems.isNotEmpty &&
        (!forceRefresh || _productItems[0]['productId'] == id)) {
      return;
    }

    clearProductDetails();
    _isLoading = true;
    notifyListeners();

    final dioClient = DioClient(context);

    try {
      final response = await dioClient.dio.get(endpoint + id);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.toString());
        final List<dynamic> productData = jsonData['data'];

        _productItems = productData.map((product) {
          // Datos básicos del producto
          final itemId = product['id'] as String;
          final name = product['product']['productName'] as String;
          final description = product['product']['description'] as String;
          final productId = product['product']['id'] as String;
          final price = product['product']['price'].toString();

          // Categorías
          final categories =
              (product['product']['categories'] as List<dynamic>?) ?? [];
          final categoryNames = categories.map((category) {
            return category['name'] as String;
          }).toList();

          // Imágenes
          final images = (product['images'] as List<dynamic>?) ?? [];
          final imageUris = images.map((image) {
            return 'http://$ip:8080/${image['imageUri']?.split('/').last ?? 'default_image.png'}';
          }).toList();

          // Colores
          final List<Map<String, dynamic>> allItems =
              productData.cast<Map<String, dynamic>>();

          final colors = allItems
              .where((item) =>
                  item['product']['id'] == productId && item['color'] != null)
              .map((item) => item['color']['colorCod'] as String)
              .toSet() // Eliminar colores duplicados
              .toList();

          final stock = product['stock'] as int;

          return {
            'name': name,
            'description': description,
            'price': price,
            'imageUris': imageUris,
            'productId': productId,
            'colors': colors,
            'categoryNames': categoryNames,
            'itemId': itemId,
            'stock': stock,
          };
        }).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Error al obtener producto');
      }
    } catch (e) {
      print('Error desconocido ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      throw Exception('Error desconocido');
    }
  }

  void clearProductDetails() {
    _productItems = [];
    notifyListeners();
  }
}
