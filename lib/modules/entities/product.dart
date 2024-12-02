import 'category.dart';

class Product {
  final String _id;
  final String _productName;
  final String _description;
  final double _price;
  final bool _state;
  final DateTime _createdAt;
  final List<Category> _categories;

  Product(
    this._id,
    this._productName,
    this._description,
    this._price,
    this._state,
    this._createdAt,
    this._categories,
  );

  String get id => _id;
  String get productName => _productName;
  String get description => _description;
  double get price => _price;
  bool get state => _state;
  DateTime get createdAt => _createdAt;
  List<Category> get categories => _categories;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'] as String,
      json['productName'] as String,
      json['description'] as String,
      (json['price'] as num).toDouble(),
      json['state'] ?? false,
      DateTime.parse(json['createdAt'] as String),
      Category.fromJsonList(json['categories'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'productName': _productName,
      'description': _description,
      'price': _price,
      'state': _state,
      'createdAt': _createdAt.toIso8601String(),
      'categories': _categories.map((category) => category.toJson()).toList(),
    };
  }

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Product.fromJson(json['item']['product']))
        .toList();
  }
}
