import 'package:flutter/material.dart';

/// Helpers centralisés pour afficher des notifications SnackBar cohérentes
/// dans toute l'application.
class AppNotification {
  AppNotification._();

  /// Affiche un SnackBar d'erreur (rouge)
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline_rounded,
      backgroundColor: const Color(0xFFE53935),
    );
  }

  /// Affiche un SnackBar de succès (vert)
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      backgroundColor: const Color(0xFF4CAF50),
    );
  }

  /// Affiche un SnackBar d'info / neutre (violet)
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline_rounded,
      backgroundColor: const Color(0xFF6C63FF),
    );
  }

  /// Affiche un SnackBar de warning réseau (orange)
  static void showNetworkWarning(BuildContext context) {
    _show(
      context,
      message: 'Mode hors-ligne — Données en cache affichées',
      icon: Icons.wifi_off_rounded,
      backgroundColor: const Color(0xFFB07800),
      duration: const Duration(seconds: 4),
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: duration,
      ),
    );
  }
}
