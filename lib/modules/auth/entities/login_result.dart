class LoginResult {
  final bool success;
  final String message;
  final String? token;
  final String? userId;
  final String? userImg;
  final String? fullName;
  final String? shoppingCartId;

  LoginResult(
      {required this.success,
      required this.message,
      this.token,
      this.userId,
      this.userImg,
      this.fullName,
      this.shoppingCartId});

  factory LoginResult.fromMap(Map<String, dynamic> map) {
    return LoginResult(
        success: map['status'] == 'success',
        message: map['message'] ?? 'No message',
        token: map['token'],
        userId: map['userId'],
        userImg: map['userImg'],
        fullName: map['fullName'],
        shoppingCartId: map['shoppingCartId']);
  }
}
