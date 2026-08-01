/// Application-level errors with user-friendly messages.
class AppException implements Exception {
  final String message;
  final String? code;
  final Object? cause;

  AppException(this.message, {this.code, this.cause});

  @override
  String toString() => message;
}
