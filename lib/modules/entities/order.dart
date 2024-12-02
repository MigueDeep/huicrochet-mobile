import 'package:huicrochet_mobile/modules/entities/cart.dart';

class Order {
  final String id;
  final Cart shoppingCart;
  final int orderDate;
  final int? estimatedDeliverDate;
  final double totalPrice;
  final String orderState;

  Order({
    required this.id,
    required this.shoppingCart,
    required this.orderDate,
    this.estimatedDeliverDate,
    required this.totalPrice,
    required this.orderState,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      shoppingCart: Cart.fromJson(json['shoppingCart']),
      orderDate: json['orderDate'] as int,
      estimatedDeliverDate: json['estimatedDeliverDate'] as int?,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      orderState: json['orderState'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shoppingCart': shoppingCart.toJson(),
      'orderDate': orderDate,
      'estimatedDeliverDate': estimatedDeliverDate,
      'totalPrice': totalPrice,
      'orderState': orderState,
    };
  }
}
