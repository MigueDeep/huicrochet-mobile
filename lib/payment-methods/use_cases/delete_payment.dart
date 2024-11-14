
import 'package:huicrochet_mobile/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/payment-methods/models/payment_method_model.dart';
import 'package:huicrochet_mobile/payment-methods/repositories/payment_method_repository.dart';

class DeletePayment {
  final PaymentMethodRepository repository;

  DeletePayment({required this.repository});

  Future<void> call(String id) async {
    return await repository.deletePaymentMethod(id);
  }
}