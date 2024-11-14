class Product {
  final String id;
  final String productName;
  final String description;
  final double price;
  final bool state;
  final DateTime createdAt;
  final List<Category> categories;
  final List<Item> items;

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.state,
    required this.createdAt,
    required this.categories,
    required this.items,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['productName'],
      description: json['description'],
      price: json['price'].toDouble(),
      state: json['state'],
      createdAt: DateTime.parse(json['createdAt']),
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}
class Category {
  final String id;
  final String name;
  final bool state;

  Category({
    required this.id,
    required this.name,
    required this.state,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      state: json['state'],
    );
  }
}

class Item {
  Item();

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item();
  }
}
