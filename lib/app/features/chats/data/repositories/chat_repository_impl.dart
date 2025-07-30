import 'package:neura_app/app/features/chats/data/datasources/chat_datasource_impl.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource datasource;

  ChatRepositoryImpl(this.datasource);

  @override
  Future<Chat> createChat() {
    return datasource.createChat();
  }

  @override
  Stream<Message> completion({
    required String chatId,
    required String content,
  }) {
    return datasource.completion(chatId: chatId, content: content);
  }

  @override
  Future<Chat> getChat({required String chatId}) {
    return datasource.getChat(chatId: chatId);
  }

  @override
  Future<void> feedbackMessage({
    required String chatId,
    required String messageId,
    required FeedbackType? feedbackType,
    required String description,
  }) {
    return datasource.feedbackMessage(
      chatId: chatId,
      messageId: messageId,
      feedbackType: feedbackType,
      description: description,
    );
  }
}
