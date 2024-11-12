
import 'package:huicrochet_mobile/payment-methods/entities/payment_method.dart';

class PaymentCardModel extends PaymentCard {
  PaymentCardModel({
    required super.userId,
    required super.cardType,
    required super.cardNumber,
    required super.expirationDate,
    required super.securityCode,
  });

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      userId: json['userId'],
      cardType: json['cardType'],
      cardNumber: json['cardNumber'],
      expirationDate: DateTime.parse(json['expirationDate']),
      securityCode: json['securityCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'expirationDate': expirationDate.toIso8601String(),
      'securityCode': securityCode,
    };
  }
}
