class PaymentCard {
  final String userId;
  final String cardType;
  final String cardNumber;
  final DateTime expirationDate;
  final String cvv;
  final String? id;
  final String? last4Numbers;
  final bool? status;

  PaymentCard(
      {required this.userId,
      required this.cardType,
      required this.cardNumber,
      required this.expirationDate,
      required this.cvv,
      this.id,
      this.last4Numbers,
      this.status});
}
