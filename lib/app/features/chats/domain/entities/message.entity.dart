import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';

class Message extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  final FeedbackType? feedbackType;
  final String? feedbackDescription;
  final bool isComplete;

  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.feedbackType,
    this.feedbackDescription = '',
    this.isComplete = true,
  });

  @override
  List<Object?> get props => [
    id,
    role,
    content,
    createdAt,
    feedbackType,
    feedbackDescription,
    isComplete,
  ];

  Message copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? createdAt,
    ValueGetter<FeedbackType?>? feedbackType,
    String? feedbackDescription,
    bool? isComplete,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      feedbackType: feedbackType != null ? feedbackType() : this.feedbackType,
      feedbackDescription: feedbackDescription ?? this.feedbackDescription,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

enum MessageRole { user, assistant }
