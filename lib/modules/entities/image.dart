class Image {
  final String _id;
  final String _name;
  final String _type;
  final String _imageUri;

  Image(this._id, this._name, this._type, this._imageUri);

  String get id => _id;
  String get name => _name;
  String get type => _type;
  String get imageUri => _imageUri;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      json['id'],
      json['name'],
      json['type'],
      json['imageUri'],
    );
  }

  static List<Image> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((image) => Image.fromJson(image)).toList();
  }
}
