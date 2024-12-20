import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:huicrochet_mobile/modules/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<List<PaymentCard>> getPaymentMethods(String userId);
  Future<PaymentCard> createPaymentMethod(PaymentCardModel paymentCard);
  Future<PaymentCard> getPaymentMethod(String id);
  Future<void> updatePaymentMethod(String id, PaymentCardModel paymentCard);
  Future<void> deletePaymentMethod(String id);
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
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            "Error fetching payment methods, status code: ${response.statusCode}");
      }
    } catch (e) {
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
  Future<PaymentCard> getPaymentMethod(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.get(
        '/payment-method/$id',
        options: Options(headers: headers),
      );

      final jsonData = jsonDecode(response.data);

      if (jsonData['status'] == 'OK' && jsonData['data'] != null) {
        return PaymentCardModel.fromJson(jsonData['data']);
      } else {
        throw Exception("Error getting payment method: ${jsonData['message']}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = jsonDecode(e.response!.data);
        throw Exception(
            "Error gettin payment method: ${errorData['message'] ?? 'Unknown error'}");
      } else {
        throw Exception('Failed to create payment method: $e');
      }
    }
  }

  @override
  Future<PaymentCard> createPaymentMethod(PaymentCardModel paymentCard) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.post(
        '/payment-method',
        data: paymentCard.toJson(),
        options: Options(headers: headers),
      );

      final jsonData = jsonDecode(response.data);

      if (jsonData['status'] == 'CREATED' && jsonData['data'] != null) {
        return PaymentCardModel.fromJson(jsonData['data']);
      } else {
        throw Exception(
            "Error creating payment method: ${jsonData['message']}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = jsonDecode(e.response!.data);
        throw Exception(
            "Error creating payment method: ${errorData['message'] ?? 'Unknown error'}");
      } else {
        throw Exception('Failed to create payment method: $e');
      }
    }
  }

  @override
  Future<void> updatePaymentMethod(
      String id, PaymentCardModel paymentCard) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.put(
        '/payment-method/$id',
        data: paymentCard.toJson(),
        options: Options(headers: headers),
      );

      final jsonData = jsonDecode(response.data);

      if (jsonData['status'] != 'OK') {
        throw Exception(
            "Error updating payment method: ${response.data['message']}");
      }
    } catch (e) {
      throw Exception('Failed to update payment method');
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await dioClient.put(
        '/payment-method/disable/$id',
        options: Options(headers: headers),
      );
      final jsonData = jsonDecode(response.data);

      if (jsonData['status'] != 'OK') {
        throw Exception(
            "Error deleting payment method: ${response.data['message']}");
      }
    } catch (e) {
      throw Exception('Failed to delete payment method');
    }
  }
}
