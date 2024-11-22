import 'package:huicrochet_mobile/modules/entities/singleItem.dart';

class CartItem {
  final String id;
  final SingleItem item;
  final int quantity;

  CartItem({
    required this.id,
    required this.item,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      item: SingleItem.fromJson(json['item']),
      quantity: json['quantity'],
    );
  }

  static List<CartItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CartItem.fromJson(json)).toList();
  }
}
