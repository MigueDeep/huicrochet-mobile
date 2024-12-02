class User {
  final String? _id;
  final String _fullName;
  final String _email;
  final DateTime _birthday;
  final bool? _status;
  final bool? _blocked;
  final String? _image;

  User(
    this._id,
    this._fullName,
    this._email,
    this._birthday,
    this._status,
    this._blocked,
    this._image,
  );

  String? get id => _id;
  String get fullName => _fullName;
  String get email => _email;
  DateTime get birthday => _birthday;
  bool? get status => _status;
  bool? get blocked => _blocked;
  String? get image => _image;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['fullName'],
      json['email'],
      DateTime.parse(json['birthday']),
      json['status'],
      json['blocked'],
      json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'fullName': _fullName,
      'email': _email,
      'birthday': _birthday.toIso8601String(),
      'status': _status,
      'blocked': _blocked,
      'image': _image,
    };
  }
}
