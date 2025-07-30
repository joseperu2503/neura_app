import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/models/loading_status.dart';
import 'package:neura_app/app/core/storage/storage_keys.dart';
import 'package:neura_app/app/core/storage/storage_service.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/presentation/blocs/chat/chat_cubit.dart';
import 'package:neura_app/app/features/chats/presentation/blocs/chat/chat_state.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_message.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_typing.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/pulse_on_tap.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/user_message.dart';
import 'package:neura_app/service_locator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ScrollPhysics _scrollPhysics = const NeverScrollableScrollPhysics();

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
    if (mounted) {
      context.read<ChatCubit>().selectChat(chatId: chatId);

      context.read<ChatCubit>().getChat(chatId: chatId);
    }
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
      _textController.text = '';
      _storageService.remove(StorageKeys.chatId);
    });
    context.read<ChatCubit>().newChat();
  }

  completion() {
    context.read<ChatCubit>().completion(content: _textController.text.trim());

    setState(() {
      _textController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = context.watch<ChatCubit>().state;
    final chat = chatState.chat;

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
          if (chat == null)
            MultiBlocListener(
              listeners: [
                BlocListener<ChatCubit, ChatState>(
                  listener: (context, state) {
                    _storageService.set(StorageKeys.chatId, state.chatId);
                  },
                  listenWhen: (previous, current) {
                    return previous.createChatLoading ==
                            LoadingStatus.loading &&
                        current.createChatLoading == LoadingStatus.success;
                  },
                ),
                BlocListener<ChatCubit, ChatState>(
                  listener: (context, state) {
                    _scrollToBottom();
                  },
                  listenWhen: (previous, current) {
                    return previous.getChatLoading == LoadingStatus.loading &&
                        current.getChatLoading == LoadingStatus.success;
                  },
                ),
              ],
              child: Expanded(
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
            ),
          if (chat != null)
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<ChatCubit, ChatState>(
                    listener: (context, state) {
                      _scrollToBottom();
                    },
                    listenWhen: (previous, current) {
                      return previous.chat?.messages != current.chat?.messages;
                    },
                  ),
                ],
                child: PulseOnTap(
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
                            final message = chat.messages[index];
                            if (message.role == MessageRole.user) {
                              return UserMessage(
                                content: chat.messages[index].content,
                              );
                            }

                            return AssistantMessage(
                              message: message,
                              chatId: chat.id,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 24);
                          },
                          itemCount: chat.messages.length,
                        ),
                      ),
                      if (chatState.completionLoading == LoadingStatus.loading)
                        const SliverPadding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Row(children: [AssistantTyping()]),
                          ),
                        ),
                    ],
                  ),
                ),
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 32,
                        bottom: 0,
                      ),
                      hintText: 'Ask Neura anything',
                      hintStyle: TextStyle(
                        color: AppColors.hintText,
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
                                          chatState.createChatLoading ==
                                              LoadingStatus.loading ||
                                          chatState.completionLoading ==
                                              LoadingStatus.loading
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
                                  chatState.createChatLoading ==
                                          LoadingStatus.loading
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
