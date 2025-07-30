import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neura_app/app/core/network/dio_client.dart';
import 'package:neura_app/app/features/chats/data/dto/chat.dto.dart';
import 'package:neura_app/app/features/chats/data/mappers/chat.mapper.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';

abstract class ChatDatasource {
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
  Stream<Message> completion({
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

      String messageId = "";

      String accumulatedText = ""; // 🔹 Acumulador de chunks

      await for (var chunk in stream) {
        String decoded = utf8.decode(chunk);

        if (decoded.startsWith('data:')) {
          final dataStr = decoded.substring(5).trim();

          final json = jsonDecode(dataStr);

          messageId = json['messageId'];
        } else {
          accumulatedText += decoded; // 🔹 Concatenamos el nuevo chunk
          yield Message(
            id: messageId,
            role: MessageRole.assistant,
            content: accumulatedText,
            createdAt: DateTime.now(),
          ); // 🔹 Emitimos el mensaje acumulado
        }
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
  Future<void> feedbackMessage({
    required String chatId,
    required String messageId,
    required FeedbackType? feedbackType,
    required String description,
  }) async {
    String? feedbackTypeString;
    if (feedbackType == FeedbackType.good) {
      feedbackTypeString = 'GOOD';
    } else if (feedbackType == FeedbackType.bad) {
      feedbackTypeString = 'BAD';
    }

    try {
      final data = {
        "chatId": chatId,
        "messageId": messageId,
        "feedbackType": feedbackTypeString,
        "feedbackDescription": description,
      };

      await dio.post('/chats/message-feedback', data: data);
    } catch (e) {
      throw 'An error occurred';
    }
  }
}
