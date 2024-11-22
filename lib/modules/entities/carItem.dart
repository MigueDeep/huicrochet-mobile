import 'item.dart';

class CartItem {
  final String _id;
  final Item _item;
  final int _quantity;

  CartItem(this._id, this._item, this._quantity);

  String get id => _id;
  Item get item => _item;
  int get quantity => _quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      json['id'] as String,
      Item.fromJson(json['item'] as Map<String, dynamic>),
      json['quantity'] as int,
    );
  }

  static List<CartItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CartItem.fromJson(json)).toList();
  }
}
