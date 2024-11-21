class Color {
  final String _id;
  final String _colorName;
  final String _colorCod;
  final bool _status;

  Color(this._id, this._colorName, this._colorCod, this._status);

  String get id => _id;
  String get colorName => _colorName;
  String get colorCod => _colorCod;
  bool get status => _status;

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      json['id'],
      json['colorName'],
      json['colorCod'],
      json['status'],
    );
  }
}
