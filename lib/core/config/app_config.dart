class AppConfig {
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbApiKey = 'YOUR_TMDB_API_KEY'; // Replace with actual key
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  static const String tokenBox = 'auth_tokens';
  static const String moviesBox = 'movies_cache';
  static const String tvShowsBox = 'tv_shows_cache';
  static const String peopleBox = 'people_cache';
}