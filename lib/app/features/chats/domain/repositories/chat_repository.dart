abstract class ChatRepository {
  Future<String> createGuestChat();

  Stream<String> guestCompletion({
    required String chatId,
    required String content,
  });
}
