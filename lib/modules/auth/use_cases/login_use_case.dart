import 'package:huicrochet_mobile/modules/auth/entities/login_result.dart';
import 'package:huicrochet_mobile/modules/auth/models/user_auth_model.dart';
import 'package:huicrochet_mobile/modules/auth/repositories/user_auth_repository.dart';
class LoginUseCase {
  final UserAuthRepository userRepository;

  LoginUseCase({required this.userRepository});

  Future<LoginResult> execute(String email, String password) async {
    try {
      final user = UserAuthModel(email: email, password: password);
      final result = await userRepository.login(user);

      return result;
    } catch (e) {
      return LoginResult(
        success: false,
        message: 'Login failed: $e',
      );
    }
  }
}
