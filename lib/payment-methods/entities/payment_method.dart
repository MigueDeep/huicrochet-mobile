class PaymentCard {
  final String userId;
  final String cardType;
  final String cardNumber;
  final DateTime expirationDate;
  final String securityCode;

  PaymentCard({
    required this.userId,
    required this.cardType,
    required this.cardNumber,
    required this.expirationDate,
    required this.securityCode,
  }); 
}
