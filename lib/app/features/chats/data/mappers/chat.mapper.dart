import 'package:neura_app/app/features/chats/data/dto/chat.dto.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';

class ChatMapper {
  static Chat fromDto(ChatDto dto) {
    return Chat(
        id: dto.id,
        title: dto.title,
        createdAt: dto.createdAt,
        messages: dto.messages
            .map(
              (e) => Message(
                role: e.role,
                content: e.content,
                createdAt: e.createdAt,
              ),
            )
            .toList());
  }
}
