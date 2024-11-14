import 'package:huicrochet_mobile/modules/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/modules/payment-methods/repositories/payment_method_repository.dart';

class UpdatePayment {
  final PaymentMethodRepository repository;

  UpdatePayment({required this.repository});

  Future<void> call(String id, PaymentCardModel paymentMethod) async {
    return await repository.updatePaymentMethod(id, paymentMethod);
  }
}
