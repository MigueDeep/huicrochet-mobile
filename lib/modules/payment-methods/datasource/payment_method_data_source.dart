import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:huicrochet_mobile/modules/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<List<PaymentCard>> getPaymentMethods(String userId);
  Future<PaymentCard> createPaymentMethod(PaymentCardModel paymentCard);
  Future<void> updatePaymentMethod(String userId, PaymentCardModel paymentCard);
  Future<void> deletePaymentMethod(String userId);
}

class PaymentMethodRemoteDataSourceImpl
    implements PaymentMethodRemoteDataSource {
  final Dio dioClient;

  PaymentMethodRemoteDataSourceImpl({required this.dioClient});

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    return token != null
        ? {
            'Authorization': 'Bearer $token',
          }
        : {};
  }

  @override
  Future<List<PaymentCard>> getPaymentMethods(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.get(
        '/payment-method/user/$userId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.data);
        if (jsonData['status'] == 'OK' && jsonData['data'] != null) {
          return (jsonData['data'] as List)
              .map((json) => PaymentCardModel.fromJson(json))
              .toList();
        } else {
          throw Exception(
              "Error fetching payment methods: ${jsonData['message']}");
        }
      } else {
        throw Exception(
            "Error fetching payment methods, status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Exception occurred: $e');
      if (e is DioException && e.response != null) {
        final errorData = jsonDecode(e.response!.data);
        throw Exception(
            "Error fetching payment methods: ${errorData['message'] ?? 'Unknown error'}");
      } else {
        throw Exception('Failed to load payment methods: $e');
      }
    }
  }

  @override
  Future<PaymentCard> createPaymentMethod(PaymentCardModel paymentCard) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.post(
        '/payment-methods',
        data: paymentCard.toJson(),
        options: Options(headers: headers),
      );

      if (response.data['status'] == 'OK' && response.data['data'] != null) {
        return PaymentCardModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            "Error creating payment method: ${response.data['message']}");
      }
    } catch (e) {
      throw Exception('Failed to create payment method');
    }
  }

  @override
  Future<void> updatePaymentMethod(
      String userId, PaymentCardModel paymentCard) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.put(
        '/payment-methods/$userId',
        data: paymentCard.toJson(),
        options: Options(headers: headers),
      );

      if (response.data['status'] != 'OK') {
        throw Exception(
            "Error updating payment method: ${response.data['message']}");
      }
    } catch (e) {
      throw Exception('Failed to update payment method');
    }
  }

  @override
  Future<void> deletePaymentMethod(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.delete(
        '/payment-methods/$userId',
        options: Options(headers: headers),
      );

      if (response.data['status'] != 'OK') {
        throw Exception(
            "Error deleting payment method: ${response.data['message']}");
      }
    } catch (e) {
      throw Exception('Failed to delete payment method');
    }
  }
}
