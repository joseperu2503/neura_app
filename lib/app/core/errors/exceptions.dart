class ServerException implements Exception {
  final String message;

  ServerException([String? message])
      : message = message ?? 'An unexpected error occurred';

  @override
  String toString() => 'ServerException: $message';
}
