import 'package:flutter/material.dart';
import 'package:neura_app/app/core/models/loading_status.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';

class ChatState {
  final List<Chat> chats;
  final String? chatId;
  final LoadingStatus createChatLoading;
  final LoadingStatus completionLoading;

  ChatState({
    this.chats = const [],
    this.chatId,
    this.createChatLoading = LoadingStatus.none,
    this.completionLoading = LoadingStatus.none,
  });

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
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      chatId: chatId != null ? chatId() : this.chatId,
      createChatLoading: createChatLoading ?? this.createChatLoading,
      completionLoading: completionLoading ?? this.completionLoading,
    );
  }
}
