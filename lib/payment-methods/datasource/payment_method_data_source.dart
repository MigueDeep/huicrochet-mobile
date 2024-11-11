import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/payment-methods/models/payment_method_model.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<PaymentCard> getPaymentMethod(String userId);
  Future<PaymentCard> createPaymentMethod(PaymentCardModel paymentCard);
  Future<PaymentCard> updatePaymentMethod(String userId, PaymentCardModel paymentCard);
  Future<void> deletePaymentMethod(String userId);
}

class PaymentMethodRemoteDataSourceImpl implements PaymentMethodRemoteDataSource {
  final DioClient dioClient;

  PaymentMethodRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<PaymentCard> getPaymentMethod(String userId) async {
    try {
      final response = await dioClient.dio.get('/payment-methods/$userId');
      return PaymentCardModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load payment method');
    }
  }

  @override
  Future<PaymentCard> createPaymentMethod(PaymentCardModel paymentCard) async {
    try {
      final response = await dioClient.dio.post('/payment-methods', data: paymentCard.toJson());
      return PaymentCardModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create payment method');
    }
  }

  @override
  Future<PaymentCard> updatePaymentMethod(String userId, PaymentCardModel paymentCard) async {
    try {
      final response = await dioClient.dio.put(
        '/payment-methods/$userId',
        data: paymentCard.toJson(),
      );
      return PaymentCardModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update payment method');
    }
  }

  @override
  Future<void> deletePaymentMethod(String userId) async {
    try {
      await dioClient.dio.delete('/payment-methods/$userId');
    } catch (e) {
      throw Exception('Failed to delete payment method');
    }
  }
}
