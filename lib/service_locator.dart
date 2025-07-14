import 'package:get_it/get_it.dart';
import 'package:neura_app/app/core/network/dio_client.dart';
import 'package:neura_app/app/core/storage/storage_service.dart';
import 'package:neura_app/app/core/token/token_service.dart';
import 'package:neura_app/app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:neura_app/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:neura_app/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:neura_app/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:neura_app/app/features/auth/domain/usecases/guest_register.dart';
import 'package:neura_app/app/features/auth/domain/usecases/is_loggued_in.dart';
import 'package:neura_app/app/features/auth/domain/usecases/logout.dart';
import 'package:neura_app/app/features/chats/data/datasources/chat_datasource_impl.dart';
import 'package:neura_app/app/features/chats/data/repositories/chat_repository_impl.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<StorageService>(
    () => SecureStorageService(),
  );
  sl.registerLazySingleton<TokenService>(
    () => TokenServiceImpl(),
  );

  sl.registerLazySingleton(() => DioClient(
        tokenService: sl<TokenService>(),
        storageService: sl<StorageService>(),
      ));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioClient>()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      storageService: sl<StorageService>(),
      tokenService: sl<TokenService>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<AuthLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<GuestRegisterUseCase>(
    () => GuestRegisterUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<IsLogguedInUseCase>(
    () => IsLogguedInUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );

  // Inyectar DataSource
  sl.registerLazySingleton<ChatDatasource>(() => ChatDatasourceImpl(
        dio: sl<DioClient>(),
      ));

  // Inyectar Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatDatasource>()),
  );
}
