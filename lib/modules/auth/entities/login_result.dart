class LoginResult {
  final bool success;
  final String message;
  final String? token;  // Si tu respuesta incluye un token

  LoginResult({
    required this.success,
    required this.message,
    this.token,
  });

  // Método para crear una instancia de LoginResult desde un Map
  factory LoginResult.fromMap(Map<String, dynamic> map) {
    return LoginResult(
      success: map['status'] == 'success',  // Puedes ajustar esto dependiendo de cómo llegue el status
      message: map['message'] ?? 'No message',
      token: map['token'],  // Si tienes un token en la respuesta// Si tienes un usuario en la respuesta
    );
  }
}
