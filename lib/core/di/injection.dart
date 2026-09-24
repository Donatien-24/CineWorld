import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_box_service.dart';

import '../../data/local/cache_service.dart';
import '../../data/local/local_storage_service.dart';
import '../../data/remote/auth_remote_data_source.dart';
import '../../data/remote/movie_remote_data_source.dart';
import '../../data/remote/person_remote_data_source.dart';
import '../../data/remote/tv_show_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/person_repository_impl.dart';
import '../../data/repositories/tv_show_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/person_repository.dart';
import '../../domain/repositories/tv_show_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/movies/movie_bloc.dart';
import '../../presentation/blocs/movie_detail/movie_detail_bloc.dart';
import '../../presentation/blocs/tv_shows/tv_show_bloc.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // --- Hive Initialization ---
  await Hive.initFlutter();
  final tokenBox = await Hive.openBox<String>('token_box');
  final cacheBox = await Hive.openBox<Map>('cache_box');

  // --- Local Storage ---
  final LocalStorageService<String> tokenStorage = HiveBoxService<String>(tokenBox);
  final LocalStorageService<Map> cacheStorage = HiveBoxService<Map>(cacheBox);

  getIt.registerSingleton<LocalStorageService<String>>(tokenStorage);
  getIt.registerSingleton<LocalStorageService<Map>>(cacheStorage);

  // --- CacheService ---
  getIt.registerSingleton<CacheService>(CacheService(cacheStorage));

  // --- Network ---
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(tokenStorage: tokenStorage),
  );

  // --- Remote Data Sources ---
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<TVShowRemoteDataSource>(
    () => TVShowRemoteDataSourceImpl(getIt<DioClient>()),
  );

  // --- Repositories ---
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      tokenStorage,
    ),
  );
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      getIt<MovieRemoteDataSource>(),
      getIt<NetworkInfo>(),
      getIt<CacheService>(),
    ),
  );
  getIt.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      getIt<PersonRemoteDataSource>(),
      getIt<NetworkInfo>(),
      getIt<CacheService>(),
    ),
  );
  getIt.registerLazySingleton<TVShowRepository>(
    () => TVShowRepositoryImpl(
      getIt<TVShowRemoteDataSource>(),
      getIt<NetworkInfo>(),
      getIt<CacheService>(),
    ),
  );

  // --- Blocs ---
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>()),
  );
  getIt.registerFactory<MovieBloc>(
    () => MovieBloc(getIt<MovieRepository>()),
  );
  getIt.registerFactory<MovieDetailBloc>(
    () => MovieDetailBloc(getIt<LocalStorageService<Map>>()),
  );
  getIt.registerFactory<TVShowBloc>(
    () => TVShowBloc(getIt<TVShowRepository>()),
  );
}
