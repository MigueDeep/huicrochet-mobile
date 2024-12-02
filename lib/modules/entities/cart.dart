import 'package:huicrochet_mobile/modules/entities/carItem.dart';

class Cart {
  final String _id;
  final bool _bought;
  final double _total;
  final List<CartItem> _cartItems;

  Cart(this._id, this._bought, this._total, this._cartItems);

  String get id => _id;
  bool get bought => _bought;
  double get total => _total;
  List<CartItem> get cartItems => _cartItems;

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      json['id'] as String,
      json['bought'] as bool,
      (json['total'] as num).toDouble(),
      CartItem.fromJsonList(json['cartItems'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bought': bought,
      'total': total,
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Cart{id: $_id, bought: $_bought, total: $_total, cartItems: $_cartItems}';
  }
}
