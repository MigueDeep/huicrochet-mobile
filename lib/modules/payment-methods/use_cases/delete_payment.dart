import 'package:huicrochet_mobile/modules/payment-methods/repositories/payment_method_repository.dart';

class DeletePayment {
  final PaymentMethodRepository repository;

  DeletePayment({required this.repository});

  Future<void> call(String id) async {
    return await repository.deletePaymentMethod(id);
  }
}
