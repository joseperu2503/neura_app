import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';
import 'package:neura_app/app/core/constants/storage_keys.dart';
import 'package:neura_app/app/core/services/storage_service.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_typing.dart';
import 'package:neura_app/app/shared/plugins/snackbar/index.dart';
import 'package:neura_app/di.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_message.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/user_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatRepository _repository = getIt<ChatRepository>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _createChatLoading = false;
  bool _completionLoading = false;

  Chat? _chat;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      getChat();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  getChat() async {
    final String? chatId = await StorageService.get<String>(StorageKeys.chatId);

    if (chatId == null) return;

    try {
      _chat = await _repository.getGuestChat(chatId: chatId);
    } catch (e) {
      SnackbarService.show(e.toString(), type: SnackbarType.error);
    }

    setState(() {
      _chat = _chat;
    });

    _scrollToBottom();
  }

  completion() async {
    final String content = _textController.text.trim();

    if (_chat == null) {
      setState(() {
        _createChatLoading = true;
      });
      _chat = await _repository.createGuestChat();

      StorageService.set(StorageKeys.chatId, _chat!.id);

      setState(() {
        _createChatLoading = false;
      });
    }

    setState(() {
      _completionLoading = true;

      _textController.text = '';
      _chat = _chat!.copyWith(messages: [
        ..._chat!.messages,
        Message(role: 'user', content: content, createdAt: DateTime.now()),
      ]);
    });

    _scrollToBottom();

    _repository.guestCompletion(chatId: _chat!.id, content: content).listen(
      (chunk) {
        _addMessage(
          message: Message(
            role: 'assistant',
            content: chunk,
            createdAt: DateTime.now(),
          ),
          pop: !_completionLoading,
        );

        if (_completionLoading) {
          setState(() {
            _completionLoading = false;
          });
        }
      },
      onDone: () {
        print("Streaming completado.");
        setState(() {
          _completionLoading = false;
        });
      },
      onError: (e) {
        print("Error en el streaming: $e");
        SnackbarService.show(e.toString(), type: SnackbarType.error);
      },
    );
  }

  void _addMessage({required Message message, bool pop = false}) {
    setState(() {
      if (pop && _chat!.messages.isNotEmpty) {
        _chat = _chat!.copyWith(
          messages: List.from(_chat!.messages)..removeLast(),
        );
      }

      _chat = _chat!.copyWith(messages: [
        ..._chat!.messages,
        message,
      ]);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void newChat() {
    setState(() {
      _chat = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dark1,
        scrolledUnderElevation: 0,
        toolbarHeight: 52,
        flexibleSpace: SafeArea(
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/neura.svg', width: 24),
                SizedBox(width: 12),
                SvgPicture.asset('assets/icons/neura_text.svg', height: 16),
                Spacer(),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: TextButton(
                    onPressed: () {
                      newChat();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/new-chat.svg',
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_chat == null)
            Expanded(
              child: Center(),
            ),
          if (_chat != null)
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                      bottom: 24,
                    ),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) {
                        final message = _chat!.messages[index];
                        if (message.role == 'user') {
                          return UserMessage(
                              content: _chat!.messages[index].content);
                        }

                        return AssistantMessage(content: message.content);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 24);
                      },
                      itemCount: _chat!.messages.length,
                    ),
                  ),
                  if (_completionLoading)
                    SliverPadding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      sliver: SliverToBoxAdapter(
                        child: Row(children: [AssistantTyping()]),
                      ),
                    ),
                ],
              ),
            ),
          Container(
            decoration: BoxDecoration(color: AppColors.dark1),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 12,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.dark2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 16,
                      ),
                      hintText: 'Ask Neura anything',
                      hintStyle: TextStyle(
                        color: AppColors.dark6,
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: ValueListenableBuilder(
                          valueListenable: _textController,
                          builder: (context, value, child) {
                            return TextButton(
                              onPressed: _textController.text == ''
                                  ? null
                                  : () {
                                      completion();
                                    },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primary2,
                                disabledBackgroundColor: AppColors.dark8,
                                padding: EdgeInsets.zero,
                              ),
                              child: _createChatLoading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: AppColors.dark6,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/send.svg',
                                      width: 24,
                                      colorFilter: ColorFilter.mode(
                                        _textController.text == ''
                                            ? AppColors.dark1
                                            : AppColors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
