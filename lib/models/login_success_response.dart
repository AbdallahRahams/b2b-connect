class LoginSuccessResponse {
  final String tokenType;
  final String expiresIn;
  final String accessToken;
  final String refreshToken;

  LoginSuccessResponse({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });
}
