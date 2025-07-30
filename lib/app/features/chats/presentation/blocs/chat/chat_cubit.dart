import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neura_app/app/core/models/loading_status.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';
import 'package:neura_app/app/features/chats/presentation/blocs/chat/chat_state.dart';
import 'package:neura_app/service_locator.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository = sl<ChatRepository>();

  ChatCubit() : super(ChatState());

  Future<void> getChat({required String chatId}) async {
    final chat = await _repository.getChat(chatId: chatId);

    emit(state.copyWith(chats: [chat]));
  }

  feedbackMessage({
    required String chatId,
    required String messageId,
    required FeedbackType? feedbackType,
    required String description,
  }) async {
    await _repository.feedbackMessage(
      chatId: chatId,
      messageId: messageId,
      feedbackType: feedbackType,
      description: description,
    );
  }

  addMessage({
    required Message message,
    required String chatId,
    bool pop = false,
  }) {
    final List<Chat> chats =
        state.chats.map((chat) {
          if (chat.id == chatId) {
            if (pop && chat.messages.isNotEmpty) {
              chat = chat.copyWith(
                messages: List.from(chat.messages)..removeLast(),
              );
            }

            chat = chat.copyWith(messages: [...chat.messages, message]);

            return chat;
          }
          return chat;
        }).toList();

    emit(state.copyWith(chats: chats));
  }

  completion({required String content}) async {
    if (state.chatId == null) {
      emit(state.copyWith(createChatLoading: LoadingStatus.loading));

      try {
        final chat = await _repository.createChat();
        final chats = [...state.chats, chat];
        emit(
          state.copyWith(
            createChatLoading: LoadingStatus.success,
            chats: chats,
            chatId: () => chat.id,
          ),
        );
      } catch (e) {
        emit(state.copyWith(createChatLoading: LoadingStatus.error));
      }
    }

    emit(state.copyWith(completionLoading: LoadingStatus.loading));

    final List<Chat> chats =
        state.chats.map((chat) {
          if (chat.id == state.chatId) {
            chat = chat.copyWith(
              messages: [
                ...chat.messages,
                Message(
                  id: DateTime.now().toString(),
                  role: MessageRole.user,
                  content: content,
                  createdAt: DateTime.now(),
                ),
              ],
            );
          }
          return chat;
        }).toList();

    emit(state.copyWith(chats: chats));

    if (state.chatId != null) {
      _repository
          .completion(chatId: state.chatId!, content: content)
          .listen(
            (chunk) {
              addMessage(
                message: chunk,
                chatId: state.chatId!,
                pop: state.completionLoading != LoadingStatus.loading,
              );

              if (state.completionLoading == LoadingStatus.loading) {
                emit(state.copyWith(completionLoading: LoadingStatus.success));
              }
            },
            onDone: () {
              emit(state.copyWith(completionLoading: LoadingStatus.success));
            },
            onError: (e) {
              emit(state.copyWith(completionLoading: LoadingStatus.error));
            },
          );
    } else {
      emit(state.copyWith(completionLoading: LoadingStatus.error));
    }
  }

  newChat() {
    emit(state.copyWith(chatId: () => null));
  }

  selectChat({required String chatId}) {
    emit(state.copyWith(chatId: () => chatId));
  }
}
