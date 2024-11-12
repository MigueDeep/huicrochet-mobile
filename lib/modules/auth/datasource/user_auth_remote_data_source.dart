import 'package:dio/dio.dart';
import 'package:huicrochet_mobile/modules/auth/entities/login_result.dart';
import 'package:huicrochet_mobile/modules/auth/models/user_auth_model.dart';// Importar el modelo LoginResult

abstract class UserAuthRemoteDataSource {
  Future<LoginResult> login(UserAuthModel user);
}

class UserRemoteDataSourceImpl implements UserAuthRemoteDataSource {
  final Dio dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LoginResult> login(UserAuthModel user) async {
    try {
      final response = await dioClient.post('/auth/signIn', data: user.toJson());

      // Convertir la respuesta del servidor a LoginResult
      return LoginResult.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
