class Category {
  final String _id;
  final String _name;
  final bool _state;

  Category(this._id, this._name, this._state);

  String get id => _id;
  String get name => _name;
  bool get state => _state;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      json['id'],
      json['name'],
      json['state'],
    );
  }

  static List<Category> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((category) => Category.fromJson(category)).toList();
  }
}
