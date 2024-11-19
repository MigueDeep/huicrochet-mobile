import 'package:huicrochet_mobile/modules/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/payment-methods/repositories/payment_method_repository.dart';

class CreatePayment {
  final PaymentMethodRepository repository;

  CreatePayment({required this.repository});

  Future<PaymentCard> call(PaymentCardModel paymentMethod) async {
    return await repository.createPaymentMethod(paymentMethod);
  }
}
