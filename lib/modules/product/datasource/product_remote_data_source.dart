import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:huicrochet_mobile/modules/product/entities/product_category.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchData();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dioClient;

  ProductRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<Product>> fetchData() async {
    try {
      final response = await dioClient.get('/product/getActiveProducts');
      final jsonData = jsonDecode(response.data);
      return (jsonData as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
