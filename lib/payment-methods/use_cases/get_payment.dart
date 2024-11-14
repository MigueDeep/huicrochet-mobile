import 'package:huicrochet_mobile/modules/shopping-cart/payment_methods.dart';
import 'package:huicrochet_mobile/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/payment-methods/repositories/payment_method_repository.dart';

class GetPayment {
  final PaymentMethodRepository repository;

  GetPayment({required this.repository});

  Future<PaymentCard> call(String id) async {
    return await repository.getPaymentMethod(id);
  }
}