import 'product.dart';

class OrderProduct {
  final Product _product;
  final int _quantity;

  OrderProduct(this._product, this._quantity);

  Product get product => _product;
  int get quantity => _quantity;

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      Product.fromJson(json['item']['product']),
      json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': {
        'product': _product.toJson(),
      },
      'quantity': _quantity,
    };
  }
}
