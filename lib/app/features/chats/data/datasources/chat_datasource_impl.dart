import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neura_app/app/core/network/dio_client.dart';
import 'package:neura_app/app/features/chats/data/dto/chat.dto.dart';
import 'package:neura_app/app/features/chats/data/mappers/chat.mapper.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';

abstract class ChatDatasource {
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

class ChatDatasourceImpl implements ChatDatasource {
  final DioClient dio;

  ChatDatasourceImpl({required this.dio});

  @override
  Future<Chat> createChat() async {
    try {
      final response = await dio.get('/chats/create');

      return ChatMapper.fromDto(ChatDto.fromJson(response.data));
    } catch (e) {
      throw 'An error occurred';
    }
  }

  @override
  Stream<String> completion({
    required String chatId,
    required String content,
  }) async* {
    try {
      final Map<String, dynamic> body = {
        "chatId": chatId,
        "content": content, // Asegúrate de usar el parámetro
      };

      Response<dynamic> response = await dio.postStream(
        '/chats/completion',
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
  Future<Chat> getChat({required String chatId}) async {
    try {
      final data = {"chatId": chatId};

      final response = await dio.post('/chats/details', data: data);

      return ChatMapper.fromDto(ChatDto.fromJson(response.data));
    } catch (e) {
      throw 'An error occurred';
    }
  }

  @override
  Future<void> approveMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final data = {"chatId": chatId, "messageId": messageId};

      await dio.post('/chats/approve', data: data);
    } catch (e) {
      throw 'An error occurred';
    }
  }

  @override
  Future<void> disapproveMessage({
    required String chatId,
    required String messageId,
    required String reason,
  }) async {
    try {
      final data = {"chatId": chatId, "messageId": messageId, "reason": reason};

      await dio.post('/chats/disapprove', data: data);
    } catch (e) {
      throw 'An error occurred';
    }
  }
}
