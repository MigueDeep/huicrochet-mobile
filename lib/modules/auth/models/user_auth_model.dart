import 'package:huicrochet_mobile/modules/auth/entities/user_auth.dart';

class UserAuthModel extends UserAuth {
  UserAuthModel({required super.email, required super.password});

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
