import 'package:huicrochet_mobile/payment-methods/datasource/payment_method_data_source.dart';
import 'package:huicrochet_mobile/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/payment-methods/models/payment_method_model.dart';

abstract class PaymentMethodRepository {
  Future<PaymentCard> getPaymentMethod(String id);
  Future<PaymentCard> createPaymentMethod(PaymentCard paymentMethod);
}

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDataSource remoteDataSource;

  PaymentMethodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaymentCard> getPaymentMethod(String id) async {
    return await remoteDataSource.getPaymentMethod(id);
  }

  @override
  Future<PaymentCard> createPaymentMethod(PaymentCard paymentMethod) async {
    return await remoteDataSource.createPaymentMethod(paymentMethod as PaymentCardModel);
  }
}
