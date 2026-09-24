# TMDB Flutter App

Une application Flutter moderne pour consulter les films et séries télévisées populaires, construite avec The Movie Database (TMDB) API.

## Fonctionnalités

- **Authentification TMDB** : Connexion via l'API officielle TMDB.
- **Liste des Films & Séries TV** : Affichage des films et séries populaires avec défilement infini (pagination) et pull-to-refresh.
- **Détails des Films** : Consultation des informations détaillées d'un film.
- **Favoris** : Possibilité d'ajouter des films en favoris (sauvegardés localement).
- **Mode Hors-Ligne** : Mise en cache locale des données pour une consultation sans connexion internet (avec bannière d'information).
- **Gestion Globale des Erreurs** : Affichage clair des erreurs réseau et serveur avec composants réutilisables (`ErrorStateView`, `AppNotification`).

## Architecture et Choix Techniques

Ce projet suit les principes de la **Clean Architecture** (Feature-first) pour assurer la maintenabilité, la testabilité et la séparation des préoccupations :

- **Domain** : Entités métiers et interfaces des Use Cases & Repositories.
- **Data** : Modèles (DTO), Data Sources (Remote via Dio, Local via Hive), et implémentation des Repositories.
- **Presentation** : Widgets de l'interface utilisateur, Écrans et BLoCs (State Management).
- **Core** : Outils partagés, configurations, injection de dépendances, gestion des exceptions réseau.

### Technologies Utilisées
- **Flutter** & **Dart** (version la plus récente).
- **State Management** : `flutter_bloc` pour une séparation stricte entre logique métier et UI.
- **Injection de Dépendances (DI)** : `get_it` (configuration manuelle sans réflexion/générateurs pour plus de légèreté et de stabilité).
- **Client HTTP** : `dio` avec intercepteurs pour l'authentification et le logging.
- **Base de Données Locale (Cache & Favoris)** : `hive` (stockage clé-valeur très rapide).
- **Architecture** : Pattern Repository & Use Case.

## Pré-requis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé sur votre machine.
- Un éditeur de code comme VS Code ou Android Studio.
- Une clé API TMDB valide.

## Installation et Lancement

1. **Cloner le repository :**
   ```bash
   git clone <url_du_repo>
   cd <nom_du_dossier>
   ```

2. **Installer les dépendances :**
   ```bash
   flutter pub get
   ```

3. **Configurer la clé API TMDB :**
   Dans le fichier `lib/core/config/constants.dart`, insérez votre jeton API (`jwtToken`) fourni par TMDB :
   ```dart
   static const String jwtToken = 'VOTRE_TOKEN_JWT_TMDB_ICI';
   ```

4. **Lancer l'application :**
   ```bash
   flutter run
   ```

## Tests

L'application dispose d'une suite complète de tests unitaires couvrant les repositories, les data sources, les entités métiers, les exceptions réseau, et les BLoCs.

Pour exécuter tous les tests :
```bash
flutter test
```

## Structure du Projet (Aperçu)

```text
lib/
 ├── core/              # DI, réseau, erreurs, utilitaires
 ├── data/              # Modèles, remote/local data sources, repositories impl
 ├── domain/            # Entités, use cases, repository interfaces
 ├── presentation/      # BLoCs, pages, widgets partagés
 └── main.dart          # Point d'entrée de l'application
```
