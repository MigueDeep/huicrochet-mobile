import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';

class NewProductsProvider with ChangeNotifier {
  List<Map<String, Object>> _newProducts = [];
  bool _isLoading = false;

  List<Map<String, Object>> get newProducts => _newProducts;
  bool get isLoading => _isLoading;

  Future<void> fetchNewProducts(BuildContext context, {bool forceRefresh = false}) async {
    if (_newProducts.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    final dioClient = DioClient(context);
    const String endpoint = '/product/getTop10';
    try {
      final response = await dioClient.dio.get(endpoint);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.toString());
        final List<dynamic> productData = jsonData['data'];

        _newProducts = productData.map((product) {
          final name = product['productName'] as String;
          final productId = product['id'] as String;
          final price = product['price'].toString();
          final imageUri = (product['items'] != null &&
                  product['items'].isNotEmpty &&
                  product['items'][0]['images'] != null &&
                  product['items'][0]['images'].isNotEmpty)
              ? product['items'][0]['images'][0]['imageUri'] as String
              : 'assets/logo.png';
          final imageName = imageUri.split('/').last;
          final uriNetwork = 'http://$ip:8080/$imageName';
          return {
            'name': name,
            'price': price,
            'imageUri': uriNetwork,
            'productId': productId
          };
        }).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        print('Error al obtener nuevos productos ${response.statusCode}');
      }
    } catch (e) {
      print('Error desconocido ${e.toString()}');
      _isLoading = false;
      notifyListeners();
    }
  }
}
