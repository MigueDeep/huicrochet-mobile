import 'package:huicrochet_mobile/modules/payment-methods/datasource/payment_method_data_source.dart';
import 'package:huicrochet_mobile/modules/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentCard>> getPaymentMethods(String userId);
  Future<PaymentCard> createPaymentMethod(PaymentCard paymentMethod);
  Future<void> updatePaymentMethod(String id, PaymentCard paymentMethod);
  Future<void> deletePaymentMethod(String id);
}

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDataSource remoteDataSource;

  PaymentMethodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PaymentCard>> getPaymentMethods(String userId) async {
    try {
      final List<PaymentCard> paymentMethods =
          await remoteDataSource.getPaymentMethods(userId);
      return paymentMethods;
    } catch (e) {
      throw Exception('Error fetching payment methods: $e');
    }
  }

  @override
  Future<PaymentCard> createPaymentMethod(PaymentCard paymentMethod) async {
    try {
      final PaymentCard paymentMethodResponse = await remoteDataSource
          .createPaymentMethod(paymentMethod as PaymentCardModel);
      return paymentMethodResponse;
    } catch (e) {
      throw Exception('Error creating payment method: $e');
    }
  }

  @override
  Future<void> updatePaymentMethod(String id, PaymentCard paymentMethod) async {
    try {
      await remoteDataSource.updatePaymentMethod(
          id, paymentMethod as PaymentCardModel);
    } catch (e) {
      throw Exception('Error updating payment method: $e');
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    try {
      await remoteDataSource.deletePaymentMethod(id);
    } catch (e) {
      throw Exception('Error deleting payment method: $e');
    }
  }
}
