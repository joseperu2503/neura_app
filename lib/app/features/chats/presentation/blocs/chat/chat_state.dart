import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:neura_app/app/core/models/loading_status.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';

class ChatState extends Equatable {
  final List<Chat> chats;
  final String? chatId;
  final LoadingStatus createChatLoading;
  final LoadingStatus completionLoading;
  final LoadingStatus getChatLoading;

  const ChatState({
    this.chats = const [],
    this.chatId,
    this.createChatLoading = LoadingStatus.none,
    this.completionLoading = LoadingStatus.none,
    this.getChatLoading = LoadingStatus.none,
  });

  @override
  List<Object?> get props => [
    chats,
    chatId,
    createChatLoading,
    completionLoading,
    getChatLoading,
    chat,
  ];

  Chat? get chat {
    final index = chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      return chats[index];
    }
    return null;
  }

  ChatState copyWith({
    List<Chat>? chats,
    ValueGetter<String?>? chatId,
    LoadingStatus? createChatLoading,
    LoadingStatus? completionLoading,
    LoadingStatus? getChatLoading,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      chatId: chatId != null ? chatId() : this.chatId,
      createChatLoading: createChatLoading ?? this.createChatLoading,
      completionLoading: completionLoading ?? this.completionLoading,
      getChatLoading: getChatLoading ?? this.getChatLoading,
    );
  }
}
