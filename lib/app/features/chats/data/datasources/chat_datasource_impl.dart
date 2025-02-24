import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neura_app/app/core/api/api.dart';
import 'package:neura_app/app/features/chats/data/dto/chat.dto.dart';
import 'package:neura_app/app/features/chats/data/mappers/chat.mapper.dart';
import 'package:neura_app/app/features/chats/domain/datasources/chat_datasource.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';

class ChatDatasourceImpl implements ChatDatasource {
  @override
  Future<Chat> createGuestChat() async {
    try {
      final response = await Api.post('/chats/guest', data: {});

      return ChatMapper.fromDto(
        ChatDto.fromJson(response.data),
      );
    } catch (e) {
      throw 'An error occurred';
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
        "content": content, // Asegúrate de usar el parámetro
      };

      Response<dynamic> response = await Api.postStream(
        '/chats/guest/completion',
        data: body,
      );
      Stream<List<int>> stream = response.data!.stream;

      String accumulatedText = ""; // 🔹 Acumulador de chunks

      await for (var chunk in stream) {
        String decoded = utf8.decode(chunk);
        accumulatedText += decoded; // 🔹 Concatenamos el nuevo chunk
        yield accumulatedText; // 🔹 Emitimos el texto acumulado
      }
    } catch (e) {
      throw 'An error occurred';
    }
  }

  @override
  Future<Chat> getGuestChat({required String chatId}) async {
    try {
      final response = await Api.get('/chats/guest/$chatId');

      return ChatMapper.fromDto(
        ChatDto.fromJson(response.data),
      );
    } catch (e) {
      throw 'An error occurred';
    }
  }
}
