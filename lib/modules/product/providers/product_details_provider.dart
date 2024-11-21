import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/modules/product/entities/product_category.dart';

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
  if (_productItems.isNotEmpty && !forceRefresh) return;
  _isLoading = true;
  notifyListeners();
  final dioClient = DioClient(context);

  try {
    final response = await dioClient.dio.get(endpoint + id);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.toString());
      final List<dynamic> productData = jsonData['data'];

      _productItems = productData.map((product) {
        final name = product['product']['productName'] as String;
        final productId = product['product']['id'] as String;
        final price = product['product']['price'].toString();
        
        // Verificar si las categorías y las imágenes existen y no son nulas
        final categories = (product['product']['categories'] as List<dynamic>?) ?? [];
        final images = (product['images'] as List<dynamic>?) ?? [];
        final color = product['color']['colorCod'] as String;

        // Manejo de imágenes
        final imageUris = images.map((image) {
          return 'http://$ip:8080/${image['imageUri']?.split('/').last ?? 'default_image.png'}';
        }).toList();

        // Manejo de categorías
        final categoryNames = categories.map((category) {
          return category['name'] as String;
        }).toList();

        return {
          'name': name,
          'price': price,
          'imageUris': imageUris,  // Guardar todas las URIs de las imágenes
          'productId': productId,
          'color': color,
          'categoryNames': categoryNames  // Guardar todos los nombres de las categorías
        };
      }).toList();

      _isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Error al obtener producto');
    }
  } catch (e) {
    print('Error desconocido ${e.toString()}');
    throw Exception('Error desconocido');
  }
}

}
