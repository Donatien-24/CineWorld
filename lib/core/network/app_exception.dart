class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  AppException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => message;

  factory AppException.fromDioError(dynamic error) {
    if (error is AppException) return error;
    
    String message = 'An unexpected error occurred';
    int? statusCode;
    String? errorCode;

    if (error.toString().contains('SocketException')) {
      message = 'No internet connection';
    } else if (error.toString().contains('TimeoutException')) {
      message = 'Request timeout';
    }

    return AppException(
      message: message,
      statusCode: statusCode,
      errorCode: errorCode,
    );
  }
}