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
      // Se obtiene la lista de métodos de pago desde el datasource
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
      // Se crea el método de pago y se obtiene la respuesta
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
      // Se actualiza el método de pago en el datasource
      await remoteDataSource.updatePaymentMethod(
          id, paymentMethod as PaymentCardModel);
    } catch (e) {
      throw Exception('Error updating payment method: $e');
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    try {
      // Se elimina el método de pago desde el datasource
      await remoteDataSource.deletePaymentMethod(id);
    } catch (e) {
      throw Exception('Error deleting payment method: $e');
    }
  }
}
