import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';

class CategoriesProvider with ChangeNotifier {
  List<String> _categories = [];
  bool _isLoading = false;

  List<String> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories(BuildContext context,
    {bool forceRefresh = false, String endpoint = "/category/getAllTrue"}) async {
  if (_categories.isNotEmpty && !forceRefresh) return;

  _isLoading = true;
  notifyListeners();

  final dioClient = DioClient(context);

  try {
    final response = await dioClient.dio.get(endpoint);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.toString());
      final List<dynamic> categoryData = jsonData['data'];

      _categories = ['Todas']; 
      _categories.addAll(
        categoryData.map((category) => category['name'] as String).toList(),
      );
      _isLoading = false;
      notifyListeners();
    } else {
      print('Error al obtener categorías ${response.statusCode}');
      _isLoading = false;
      notifyListeners();
    }
  } catch (e) {
    print('Error desconocido ${e.toString()}');
    _isLoading = false;
    notifyListeners();
  }
}

}
