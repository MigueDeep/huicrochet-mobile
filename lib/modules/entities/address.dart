import 'package:huicrochet_mobile/modules/entities/user.dart';

class Address {
  final String? _id;
  final String _state;
  final String _city;
  final String _zipCode;
  final String _district;
  final String _street;
  final String _number;
  final String _phoneNumber;
  bool _default;
  final bool _status;
  final User _user;

  Address(
      this._id,
      this._state,
      this._city,
      this._zipCode,
      this._district,
      this._street,
      this._number,
      this._phoneNumber,
      this._default,
      this._status,
      this._user);

  String? get id => _id;
  String get state => _state;
  String get city => _city;
  String get zipCode => _zipCode;
  String get district => _district;
  String get street => _street;
  String get number => _number;
  String get phoneNumber => _phoneNumber;
  bool get defaultAddress => _default;
  set defaultAddress(bool value) {
    _default = value;
  }

  bool get status => _status;
  User get user => _user;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      json['id'],
      json['state'],
      json['city'],
      json['zipCode'],
      json['district'],
      json['street'],
      json['number'],
      json['phoneNumber'],
      json['default'] ?? false,
      json['status'] ?? false,
      User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'state': _state,
      'city': _city,
      'zipCode': _zipCode,
      'district': _district,
      'street': _street,
      'number': _number,
      'phoneNumber': _phoneNumber,
      'default': _default,
      'status': _status,
      'user': _user.toJson(),
    };
  }
}
