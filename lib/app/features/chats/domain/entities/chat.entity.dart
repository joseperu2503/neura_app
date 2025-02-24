// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';

class Chat {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<Message> messages;

  Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  Chat copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    List<Message>? messages,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      messages: messages ?? this.messages,
    );
  }
}
