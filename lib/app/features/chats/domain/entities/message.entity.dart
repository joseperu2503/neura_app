import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';

class Message {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  final FeedbackType? feedbackType;
  final String? feedbackDescription;

  Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.feedbackType,
    this.feedbackDescription = '',
  });
}

enum MessageRole { user, assistant }
