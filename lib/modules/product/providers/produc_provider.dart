import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';

class ProductsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts(BuildContext context,
      {bool forceRefresh = false,
      String endpoint = "/item/getDistinctItemsByProduct"}) async {
    if (_products.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    final dioClient = DioClient(context);

    try {
      final response = await dioClient.dio.get(endpoint);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.toString());
        final List<dynamic> productData = jsonData['data'];

        _products = productData.map((product) {
          final name = product['product']['productName'] as String;
          final productId = product['product']['id'] as String;
          final price = product['product']['price'].toString();

          final images = product['images'] as List<dynamic>;
          String imageUri = 'assets/logo.png';
          if (images.isNotEmpty) {
            final firstImage = images[0];
            if (firstImage != null &&
                (images).isNotEmpty) {
              imageUri = firstImage['imageUri'] as String;
            }
          }

          final imagePath = imageUri.split('/').last;
          final uriNetwork = 'http://$ip:8080/$imagePath';

          return {
            'name': name,
            'price': price,
            'imageUri': uriNetwork,
            'productId': productId,
          };
        }).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        print('Error al obtener productos ${response.statusCode}');
      }
    } catch (e) {
      print('Error desconocido ${e.toString()}');
      _isLoading = false;
      notifyListeners();
    }
  }
}
