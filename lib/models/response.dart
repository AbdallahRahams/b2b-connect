class ResponseMessage {
  bool error;
  bool unauthorized;
  String message;

  ResponseMessage({
    required this.error,
    required this.unauthorized,
    required this.message,
  });
}
