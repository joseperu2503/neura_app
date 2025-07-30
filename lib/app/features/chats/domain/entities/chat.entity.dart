// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';

class Chat extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<Message> messages;

  const Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, title, createdAt, messages];

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
