import 'product.dart';
import 'color.dart';
import 'image.dart';

class Item {
  final String _id;
  final Product _product;
  final Color _color;
  final int _stock;
  final bool _state;
  final List<Image> _images;

  Item(this._id, this._product, this._color, this._stock, this._state,
      this._images);

  String get id => _id;
  Product get product => _product;
  Color get color => _color;
  int get stock => _stock;
  bool get state => _state;
  List<Image> get images => _images;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'] as String,
      Product.fromJson(json['product'] as Map<String, dynamic>),
      Color.fromJson(json['color'] as Map<String, dynamic>),
      json['stock'] as int,
      json['state'] as bool,
      Image.fromJsonList(json['images'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'product': _product.toJson(),
      'color': _color.toJson(),
      'stock': _stock,
      'state': _state,
      'images': _images.map((image) => image.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Item{id: $_id, product: $_product, color: $_color, stock: $_stock, state: $_state, images: $_images}';
  }
}
