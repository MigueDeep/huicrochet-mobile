import 'product.dart';
import 'color.dart';
import 'image.dart';

class SingleItem {
  final String _id;
  final Product _product;
  final Color _color;
  final int _stock;
  final bool _state;
  final List<Image> _images;

  SingleItem(
    this._id,
    this._product,
    this._color,
    this._stock,
    this._state,
    this._images,
  );

  String get id => _id;
  Product get product => _product;
  Color get color => _color;
  int get stock => _stock;
  bool get state => _state;
  List<Image> get images => _images;

  factory SingleItem.fromJson(Map<String, dynamic> json) {
    return SingleItem(
      json['id'],
      Product.fromJson(json['product']),
      Color.fromJson(json['color']),
      json['stock'],
      json['state'],
      Image.fromJsonList(json['images']),
    );
  }
}
