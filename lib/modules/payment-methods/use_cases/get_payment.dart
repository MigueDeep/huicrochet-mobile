import 'package:huicrochet_mobile/modules/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/modules/payment-methods/repositories/payment_method_repository.dart';

class GetPayment {
  final PaymentMethodRepository repository;

  GetPayment({required this.repository});

  Future<List<PaymentCard>> call(String id) async {
    return await repository.getPaymentMethods(id);
  }
}
