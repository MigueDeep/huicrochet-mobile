import 'category.dart';
import 'item.dart';

class Product {
  final String _id;
  final String _productName;
  final String _description;
  final double _price;
  final bool _state;
  final DateTime _createdAt;
  final List<Category> _categories;
  final List<Item> _items;

  Product(
    this._id,
    this._productName,
    this._description,
    this._price,
    this._state,
    this._createdAt,
    this._categories,
    this._items,
  );

  String get id => _id;
  String get productName => _productName;
  String get description => _description;
  double get price => _price;
  bool get state => _state;
  DateTime get createdAt => _createdAt;
  List<Category> get categories => _categories;
  List<Item> get items => _items;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'],
      json['productName'],
      json['description'],
      (json['price'] as num).toDouble(),
      json['state'],
      DateTime.parse(json['createdAt']),
      Category.fromJsonList(json['categories']),
      Item.fromJsonList(json['items']),
    );
  }
}
