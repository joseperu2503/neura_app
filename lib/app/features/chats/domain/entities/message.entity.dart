import 'package:equatable/equatable.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';

class Message extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  final FeedbackType? feedbackType;
  final String? feedbackDescription;

  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.feedbackType,
    this.feedbackDescription = '',
  });

  @override
  List<Object?> get props => [
    id,
    role,
    content,
    createdAt,
    feedbackType,
    feedbackDescription,
  ];
}

enum MessageRole { user, assistant }
