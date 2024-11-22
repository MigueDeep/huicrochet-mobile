import 'package:huicrochet_mobile/modules/entities/carItem.dart';

class Cart {
  final String id;
  final bool bought;
  final double total;
  final List<CartItem> cartItems;

  Cart({
    required this.id,
    required this.bought,
    required this.total,
    required this.cartItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      bought: json['bought'],
      total: json['total'].toDouble(),
      cartItems: CartItem.fromJsonList(json['cartItems']),
    );
  }
}
