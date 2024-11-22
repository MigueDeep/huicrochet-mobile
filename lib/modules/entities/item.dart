import 'color.dart';
import 'image.dart';

class Item {
  final String _id;
  final Color _color;
  final int _stock;
  final bool _state;
  final List<Image> _images;

  Item(this._id, this._color, this._stock, this._state, this._images);

  String get id => _id;
  Color get color => _color;
  int get stock => _stock;
  bool get state => _state;
  List<Image> get images => _images;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'],
      Color.fromJson(json['color']),
      json['stock'],
      json['state'],
      (json['images'] as List).map((img) => Image.fromJson(img)).toList(),
    );
  }

  static List<Item> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Item.fromJson(item)).toList();
  }
}
