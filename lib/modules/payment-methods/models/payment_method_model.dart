import 'package:huicrochet_mobile/modules/payment-methods/entities/payment_method.dart';

class PaymentCardModel extends PaymentCard {
  PaymentCardModel({
    String? id,
    required String userId,
    required String cardType,
    required String cardNumber,
    required DateTime expirationDate,
    required String cvv,
    String? last4Numbers,
    bool? status,
  }) : super(
          id: id,
          userId: userId,
          cardType: cardType,
          cardNumber: cardNumber,
          expirationDate: expirationDate,
          cvv: cvv,
          last4Numbers: last4Numbers,
          status: status,
        );

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      id: json['id'],
      userId: json['userId'] ?? '',
      cardType: json['cardType'],
      cardNumber: json['cardNumber'],
      expirationDate: _parseExpirationDate(json['expirationDate']),
      cvv: json['cvv'],
      last4Numbers: json['last4Numbers'] ?? '',
      status:
          json['status'] is bool ? json['status'] : json['status'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'expirationDate': expirationDate.toIso8601String(),
      'cvv': cvv,
      'last4Numbers': last4Numbers,
      'status': status,
    };
  }

  static DateTime _parseExpirationDate(String expirationDate) {
    final parts = expirationDate.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]) + 2000;
    return DateTime(year, month, 1);
  }
}
