import 'package:neura_app/app/features/chats/data/datasources/chat_datasource_impl.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource datasource;

  ChatRepositoryImpl(this.datasource);

  @override
  Future<Chat> createChat() {
    return datasource.createChat();
  }

  @override
  Stream<String> completion({required String chatId, required String content}) {
    return datasource.completion(chatId: chatId, content: content);
  }

  @override
  Future<Chat> getChat({required String chatId}) {
    return datasource.getChat(chatId: chatId);
  }

  @override
  Future<void> approveMessage({
    required String chatId,
    required String messageId,
  }) {
    return datasource.approveMessage(chatId: chatId, messageId: messageId);
  }

  @override
  Future<void> disapproveMessage({
    required String chatId,
    required String messageId,
    required String reason,
  }) {
    return datasource.disapproveMessage(
      chatId: chatId,
      messageId: messageId,
      reason: reason,
    );
  }
}
