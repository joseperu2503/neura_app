import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';

abstract class ChatRepository {
  Future<Chat> createGuestChat();

  Stream<String> guestCompletion({
    required String chatId,
    required String content,
  });

  Future<Chat> getGuestChat({
    required String chatId,
  });
}
