class Category {
  String id;
  String name;
  bool state;

  Category({
    required this.id,
    required this.name,
    required this.state,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      state: json['state'] as bool,
    );
  }
}

class Color {
  String id;
  String colorName;
  String colorCod;
  bool status;

  Color({
    required this.id,
    required this.colorName,
    required this.colorCod,
    required this.status,
  });

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      id: json['id'] as String,
      colorName: json['colorName'] as String,
      colorCod: json['colorCod'] as String,
      status: json['status'] as bool,
    );
  }
}

class Image {
  String id;
  String name;
  String type;
  String imageUri;

  Image({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUri,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      imageUri: json['imageUri'] as String,
    );
  }

}

class Item {
  String id;
  Color color;
  int stock;
  bool state;
  List<Image> images;

  Item({
    required this.id,
    required this.color,
    required this.stock,
    required this.state,
    required this.images,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    var imagesFromJson = json['images'] as List? ?? [];
    List<Image> imagesList = imagesFromJson
        .map((imageJson) => Image.fromJson(imageJson))
        .toList();

    return Item(
      id: json['id'] as String,
      color: Color.fromJson(json['color']),
      stock: json['stock'] as int,
      state: json['state'] as bool,
      images: imagesList,
    );
  }
}

class Product {
  String id;
  String name;
  String description;
  String price;
  List<Category> categories;
  List<Item> items;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categories,
    required this.items,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Procesar la lista de categorías
    var categoriesFromJson = json['categories'] as List? ?? [];
    List<Category> categoriesList = categoriesFromJson
        .map((categoryJson) => Category.fromJson(categoryJson))
        .toList();

    // Procesar la lista de items
    var itemsFromJson = json['items'] as List? ?? [];
    List<Item> itemsList = itemsFromJson
        .map((itemJson) => Item.fromJson(itemJson))
        .toList();

    return Product(
      id: json['id'] as String,
      name: json['productName'] as String,
      description: json['description'] as String,
      price: json['price'].toString(),
      categories: categoriesList,
      items: itemsList,
    );
  }
}