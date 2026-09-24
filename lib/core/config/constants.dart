class AppConstants {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tokenExpiryKey = 'token_expiry';
  
  static const String cachedAtKey = 'cached_at';
  static const Duration cacheExpiry = Duration(hours: 1);
  
  static const String popularMoviesEndpoint = '/movie/popular';
  static const String topRatedMoviesEndpoint = '/movie/top_rated';
  static const String popularTVShowsEndpoint = '/tv/popular';
  static const String popularPeopleEndpoint = '/person/popular';
  
  static const String loginEndpoint = '/authentication/token/validate_with_login';
  static const String requestTokenEndpoint = '/authentication/token/new';
  static const String sessionEndpoint = '/authentication/session/new';
  static const String tmdbSignupUrl = 'https://www.themoviedb.org/signup';
}