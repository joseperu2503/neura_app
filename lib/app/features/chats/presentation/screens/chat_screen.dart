import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/storage/storage_keys.dart';
import 'package:neura_app/app/core/storage/storage_service.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/app/features/auth/domain/usecases/guest_register.dart';
import 'package:neura_app/app/features/chats/domain/entities/chat.entity.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_message.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_typing.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/user_message.dart';
import 'package:neura_app/app/shared/plugins/snackbar/index.dart';
import 'package:neura_app/service_locator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatRepository _repository = sl<ChatRepository>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _createChatLoading = false;
  bool _completionLoading = false;
  ScrollPhysics _scrollPhysics = const NeverScrollableScrollPhysics();

  Chat? _chat;

  final GuestRegisterUseCase _guestRegisterUseCase = sl<GuestRegisterUseCase>();

  final _storageService = sl<StorageService>();

  @override
  void initState() {
    super.initState();
    getChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  getChat() async {
    final String? chatId = await _storageService.get<String>(
      StorageKeys.chatId,
    );

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

      try {
        _chat = await _repository.createGuestChat();
      } catch (e) {
        setState(() {
          _createChatLoading = false;
        });
        SnackbarService.show(e.toString(), type: SnackbarType.error);
      }

      _storageService.set(StorageKeys.chatId, _chat!.id);

      setState(() {
        _createChatLoading = false;
      });
    }

    setState(() {
      _completionLoading = true;

      _textController.text = '';
      _chat = _chat!.copyWith(
        messages: [
          ..._chat!.messages,
          Message(role: 'user', content: content, createdAt: DateTime.now()),
        ],
      );
    });

    _scrollToBottom();

    _repository
        .guestCompletion(chatId: _chat!.id, content: content)
        .listen(
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
            setState(() {
              _completionLoading = false;
            });
          },
          onError: (e) {
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

      _chat = _chat!.copyWith(messages: [..._chat!.messages, message]);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.hasClients) {
        setState(() {
          _scrollPhysics = const ClampingScrollPhysics();
        });
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        setState(() {
          _scrollPhysics = const BouncingScrollPhysics();
        });
      }
    });
  }

  void newChat() {
    setState(() {
      _chat = null;
      _textController.text = '';
      _storageService.remove(StorageKeys.chatId);
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/neura.svg', width: 24),
                const SizedBox(width: 12),
                SvgPicture.asset('assets/icons/neura_text.svg', height: 16),
                const Spacer(),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: TextButton(
                    onPressed: () {
                      newChat();
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: SvgPicture.asset(
                      'assets/icons/new-chat.svg',
                      width: 24,
                      colorFilter: const ColorFilter.mode(
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/neura.svg', width: 40),
                        const SizedBox(width: 8),
                        const Text(
                          "Hi, I'm Neura.",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            height: 32 / 24,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "How can I help you today?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.dark9,
                        height: 1.5,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_chat != null)
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                physics: _scrollPhysics,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(
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
                            content: _chat!.messages[index].content,
                          );
                        }

                        return AssistantMessage(content: message.content);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 24);
                      },
                      itemCount: _chat!.messages.length,
                    ),
                  ),
                  if (_completionLoading)
                    const SliverPadding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      sliver: SliverToBoxAdapter(
                        child: Row(children: [AssistantTyping()]),
                      ),
                    ),
                ],
              ),
            ),
          Container(
            decoration: const BoxDecoration(color: AppColors.dark1),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 12,
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                color: AppColors.dark2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 32,
                        bottom: 0,
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
                        width: 36,
                        height: 36,
                        child: ValueListenableBuilder(
                          valueListenable: _textController,
                          builder: (context, value, child) {
                            final textValid =
                                _textController.text.trim().isNotEmpty;

                            return TextButton(
                              onPressed:
                                  !textValid ||
                                          _createChatLoading ||
                                          _completionLoading
                                      ? null
                                      : () {
                                        completion();
                                      },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.primary
                                    .withAlpha(100),
                                padding: EdgeInsets.zero,
                              ),
                              child:
                                  _createChatLoading
                                      ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: AppColors.dark6,
                                        ),
                                      )
                                      : SvgPicture.asset(
                                        'assets/icons/arrow-up.svg',
                                        width: 24,
                                        colorFilter: ColorFilter.mode(
                                          textValid
                                              ? AppColors.white
                                              : AppColors.dark6.withAlpha(200),
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
