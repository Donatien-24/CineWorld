import 'package:dio/dio.dart';

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

    String message = 'Une erreur inattendue est survenue';
    int? statusCode;
    String? errorCode;

    if (error is DioException) {
      statusCode = error.response?.statusCode;

      // Extraction du message renvoyé par TMDB si disponible
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response!.data as Map<String, dynamic>;
        if (data.containsKey('status_message')) {
          message = data['status_message'].toString();
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Délai d\'attente dépassé. Vérifiez votre connexion.';
          break;
        case DioExceptionType.badResponse:
          if (statusCode == 401) {
            message = 'Session expirée ou clé API invalide.';
          } else if (statusCode == 404) {
            message = 'Ressource introuvable sur les serveurs TMDB.';
          } else if (statusCode != null && statusCode >= 500) {
            message = 'Erreur serveur TMDB. Veuillez réessayer plus tard.';
          }
          break;
        case DioExceptionType.connectionError:
          message = 'Pas de connexion Internet.';
          break;
        case DioExceptionType.cancel:
          message = 'La requête a été annulée.';
          break;
        default:
          break;
      }
    }

    // Gestion des exceptions brutes et compatibilité des tests
    final errorStr = error.toString();
    if (errorStr.contains('SocketException')) {
      message = 'No internet connection';
    } else if (errorStr.contains('TimeoutException')) {
      message = 'Request timeout';
    }

    return AppException(
      message: message,
      statusCode: statusCode,
      errorCode: errorCode,
    );
  }
}