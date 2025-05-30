import 'package:neura_app/app/features/chats/data/datasources/chat_datasource_impl.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource datasource;

  ChatRepositoryImpl(this.datasource);

  @override
  Future<Chat> createGuestChat() {
    return datasource.createGuestChat();
  }

  @override
  Stream<String> guestCompletion({
    required String chatId,
    required String content,
  }) {
    return datasource.guestCompletion(chatId: chatId, content: content);
  }

  @override
  Future<Chat> getGuestChat({required String chatId}) {
    return datasource.getGuestChat(chatId: chatId);
  }
}
