import 'dart:convert';

import 'package:dio/dio.dart';
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

  @override
  Stream<String> guestCompletion({
    required String chatId,
    required String content,
  }) async* {
    try {
      final Map<String, dynamic> body = {
        "chatId": chatId,
        "content": "Conoces peru?",
      };

      Response<dynamic> response = await Api.postStream(
        '/chats/guest/completion',
        data: body,
      );
      Stream<List<int>> stream = response.data!.stream;

      await for (var chunk in stream) {
        String decoded = utf8.decode(chunk);
        yield decoded;
      }
    } catch (e) {
      throw Exception('An error occurred');
    }
  }
}
