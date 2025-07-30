import 'package:neura_app/app/features/chats/data/dto/chat.dto.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';

class ChatMapper {
  static Chat fromDto(ChatDto dto) {
    return Chat(
      id: dto.id,
      title: dto.title,
      createdAt: dto.createdAt,
      messages:
          dto.messages
              .map(
                (e) => Message(
                  id: e.id,
                  role:
                      e.role == 'user'
                          ? MessageRole.user
                          : MessageRole.assistant,
                  content: e.content,
                  createdAt: e.createdAt,
                  feedbackType:
                      e.feedbackType != null
                          ? e.feedbackType == 'GOOD'
                              ? FeedbackType.good
                              : FeedbackType.bad
                          : null,
                  feedbackDescription: e.feedbackDescription,
                ),
              )
              .toList(),
    );
  }
}
