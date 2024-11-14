import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:huicrochet_mobile/modules/auth/entities/login_result.dart';
import 'package:huicrochet_mobile/modules/auth/models/user_auth_model.dart'; 
abstract class UserAuthRemoteDataSource {
  Future<LoginResult> login(UserAuthModel user);
}

class UserRemoteDataSourceImpl implements UserAuthRemoteDataSource {
  final Dio dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LoginResult> login(UserAuthModel user) async {
    try {
      final response =
          await dioClient.post('/auth/signIn', data: user.toJson());

      final jsonData = jsonDecode(response.data);
      if (response.statusCode == 200) {
        return LoginResult(
            success: true,
            message: jsonData['message'],
            token: jsonData['data']['token'],
            userId: jsonData['data']['user']['id'],
            userImg: jsonData['data']['user']['image']['imageUri'],
            fullName: jsonData['data']['user']['fullName']
            );
            
      } else {
        return LoginResult(
          success: false,
          message: jsonData['message'] ?? 'An unknown error occurred',
        );
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = jsonDecode(e.response!.data);
        return LoginResult(
          success: false,
          message: errorData['message'] ?? 'Login failed',
        );
      } else {
        return LoginResult(
          success: false,
          message: 'An unexpected error occurred: $e',
        );
      }
    }
  }
}
