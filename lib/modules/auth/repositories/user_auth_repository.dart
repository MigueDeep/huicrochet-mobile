import 'package:huicrochet_mobile/modules/auth/datasource/user_auth_remote_data_source.dart';
import 'package:huicrochet_mobile/modules/auth/entities/login_result.dart';
import 'package:huicrochet_mobile/modules/auth/models/user_auth_model.dart';

abstract class UserAuthRepository {
  Future<LoginResult> login(UserAuthModel user);
}

class UserRepositoryImpl implements UserAuthRepository {
  final UserAuthRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResult> login(UserAuthModel user) async {
    final result = await remoteDataSource.login(user);

    if (result.success) {
      return LoginResult(
        success: true,
        message: result.message,
        token: result.token,
        userId: result.userId,
        userImg: result.userImg,
        fullName: result.fullName,
        shoppingCartId: result.shoppingCartId,
      );
    } else {
      return LoginResult(
        success: false,
        message: result.message,
      );
    }
  }
}
