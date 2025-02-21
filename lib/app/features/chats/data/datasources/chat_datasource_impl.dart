import 'package:neura_app/app/core/api/api.dart';
import 'package:neura_app/app/features/chats/data/dto/create_chat_guest_response.dto.dart';
import 'package:neura_app/app/features/chats/domain/datasources/chat_datasource.dart';

class ChatDatasourceImpl implements ChatDatasource {
  @override
  Future<String> createGuestChat() async {
    try {
      final response = await Api.post('/chats/guest');

      final String? id = CreateChatGuestResponseDto.fromJson(response.data).id;

      if (id == null) {
        throw Exception();
      }

      return id;
    } catch (e) {
      throw Exception('An error occurred');
    }
  }
}
