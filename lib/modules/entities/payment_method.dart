class PaymentMethod {
  final String id;
  final String cardType;
  final String cardNumber;
  final String expirationDate;
  final String last4Numbers;
  final String cvv;
  final bool status;

  PaymentMethod({
    required this.id,
    required this.cardType,
    required this.cardNumber,
    required this.expirationDate,
    required this.last4Numbers,
    required this.cvv,
    required this.status,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      cardType: json['cardType'] as String,
      cardNumber: json['cardNumber'] as String,
      expirationDate: json['expirationDate'] as String,
      last4Numbers: json['last4Numbers'] as String,
      cvv: json['cvv'] as String,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'expirationDate': expirationDate,
      'last4Numbers': last4Numbers,
      'cvv': cvv,
      'status': status,
    };
  }
}
