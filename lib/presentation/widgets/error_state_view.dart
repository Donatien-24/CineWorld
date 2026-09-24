import 'package:flutter/material.dart';

/// Widget réutilisable d'affichage d'état d'erreur.
/// Affiche une icône, un titre, un message et un bouton de réessai optionnel.
class ErrorStateView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onRetry;
  final String retryLabel;

  const ErrorStateView({
    super.key,
    this.title = 'Connexion impossible',
    required this.message,
    this.icon = Icons.wifi_off_rounded,
    this.iconColor = const Color(0xFF6C63FF),
    this.onRetry,
    this.retryLabel = 'Réessayer',
  });

  /// Constructeur d'erreur réseau (cas le plus courant)
  factory ErrorStateView.network({
    Key? key,
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorStateView(
      key: key,
      title: 'Connexion impossible',
      message: message,
      icon: Icons.wifi_off_rounded,
      iconColor: const Color(0xFF6C63FF),
      onRetry: onRetry,
    );
  }

  /// Constructeur d'erreur serveur
  factory ErrorStateView.server({
    Key? key,
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorStateView(
      key: key,
      title: 'Erreur serveur',
      message: message,
      icon: Icons.cloud_off_rounded,
      iconColor: const Color(0xFFE53935),
      onRetry: onRetry,
    );
  }

  /// Constructeur pour contenu vide
  factory ErrorStateView.empty({
    Key? key,
    String message = 'Aucun contenu à afficher.',
  }) {
    return ErrorStateView(
      key: key,
      title: 'Rien ici',
      message: message,
      icon: Icons.inbox_rounded,
      iconColor: const Color(0xFF3B82F6),
      onRetry: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône dans un conteneur arrondi
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: iconColor, size: 40),
            ),
            const SizedBox(height: 20),
            // Titre
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            // Bouton de réessai (optionnel)
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
