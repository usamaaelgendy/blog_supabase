class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class ServerException extends AppException {
  ServerException(super.message, [super.code]);
}

class AuthException extends AppException {
  AuthException(super.message, [super.code]);
}

class ValidationException extends AppException {
  ValidationException(super.message, [super.code]);
}

class NetworkException extends AppException {
  NetworkException(super.message, [super.code]);
}

class CacheException extends AppException {
  CacheException(super.message, [super.code]);
}