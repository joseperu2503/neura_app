import 'package:get_it/get_it.dart';
import 'package:neura_app/app/features/chats/data/datasources/chat_datasource_impl.dart';
import 'package:neura_app/app/features/chats/data/repositories/chat_repository_impl.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';

final getIt = GetIt.instance;

void setup() {
  // Inyectar DataSource
  getIt.registerLazySingleton<ChatDatasource>(() => ChatDatasourceImpl());

  // Inyectar Repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatDatasource>()),
  );
}
