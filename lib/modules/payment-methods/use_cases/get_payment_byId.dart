import 'package:huicrochet_mobile/modules/payment-methods/entities/payment_method.dart';
import 'package:huicrochet_mobile/modules/payment-methods/repositories/payment_method_repository.dart';

class GetPaymentByid {
  final PaymentMethodRepository repository;

  GetPaymentByid({required this.repository});

  Future<PaymentCard> call(String id) async {
    return await repository.getPaymentMethod(id);
  }
}
