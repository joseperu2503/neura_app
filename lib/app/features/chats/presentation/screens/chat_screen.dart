import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/assistant_typing.dart';
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
  bool _loading = false;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  completion() async {
    final String content = _textController.text.trim();
    setState(() {
      _messages = [
        ..._messages,
        Message(role: 'user', content: content, createdAt: DateTime.now()),
      ];

      _loading = true;
      _textController.text = '';
    });
    final String chatId = await _repository.createGuestChat();

    _repository.guestCompletion(chatId: chatId, content: content).listen(
      (chunk) {
        _addMessage(
          message: Message(
            role: 'assistant',
            content: chunk,
            createdAt: DateTime.now(),
          ),
          pop: !_loading,
        );

        if (_loading) {
          setState(() {
            _loading = false;
          });
        }
      },
      onDone: () {
        print("Streaming completado.");
      },
      onError: (error) {
        print("Error en el streaming: $error");
      },
    );
  }

  void _addMessage({required Message message, bool pop = false}) {
    setState(() {
      if (pop && _messages.isNotEmpty) {
        _messages.removeLast(); // 🔹 Elimina el último mensaje si `pop` es true
      }
      _messages = [..._messages, message];
    });

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
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
                      final message = _messages[index];
                      if (message.role == 'user') {
                        return UserMessage(content: _messages[index].content);
                      }

                      return AssistantMessage(content: message.content);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 24);
                    },
                    itemCount: _messages.length,
                  ),
                ),
                if (_loading)
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
                              child: SvgPicture.asset(
                                'assets/icons/send.svg',
                                width: 20,
                                colorFilter: ColorFilter.mode(
                                  _textController.text == ''
                                      ? AppColors.dark4
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
