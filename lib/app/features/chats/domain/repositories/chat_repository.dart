import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';

abstract class ChatRepository {
  Future<Chat> createChat();

  Stream<String> completion({required String chatId, required String content});

  Future<Chat> getChat({required String chatId});

  Future<void> approveMessage({
    required String chatId,
    required String messageId,
  });

  Future<void> disapproveMessage({
    required String chatId,
    required String messageId,
    required String reason,
  });
}
