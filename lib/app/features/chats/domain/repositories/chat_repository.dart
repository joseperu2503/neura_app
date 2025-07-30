import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';

abstract class ChatRepository {
  Future<Chat> createChat();

  Stream<Message> completion({required String chatId, required String content});

  Future<Chat> getChat({required String chatId});

  Future<void> feedbackMessage({
    required String chatId,
    required String messageId,
    required FeedbackType? feedbackType,
    required String description,
  });
}
