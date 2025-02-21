import 'package:neura_app/app/features/chats/domain/datasources/chat_datasource.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource datasource;

  ChatRepositoryImpl(this.datasource);

  @override
  Future<String> createGuestChat() {
    return datasource.createGuestChat();
  }
}
