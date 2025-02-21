import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';
import 'package:neura_app/app/di.dart';
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
  final ChatRepository repository = getIt<ChatRepository>();
  final TextEditingController textController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  completion() async {
    print(textController.text);
    final String content = textController.text.trim();
    setState(() {
      messages = [
        ...messages,
        Message(role: 'user', content: content, createdAt: DateTime.now()),
      ];

      loading = true;
      textController.text = '';
    });
    final String chatId = await repository.createGuestChat();

    repository
        .guestCompletion(chatId: chatId, content: content)
        .listen(
          (chunk) {
            // print("Chunk recibido: $chunk");

            addMessage(
              message: Message(
                role: 'assistant',
                content: chunk,
                createdAt: DateTime.now(),
              ),
              pop: !loading,
            );

            if (loading) {
              setState(() {
                loading = false;
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

  addMessage({required Message message, bool pop = false}) {
    setState(() {
      if (pop && messages.isNotEmpty) {
        messages.removeLast(); // 🔹 Elimina el último mensaje si `pop` es true
      }
      messages = [...messages, message];
    });
  }

  List<Message> messages = [];

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
                SvgPicture.asset(
                  'assets/icons/menu.svg',
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 16),
                SvgPicture.asset(
                  'assets/icons/neura_text_white.svg',
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 24,
                    bottom: 16,
                  ),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      if (message.role == 'user') {
                        return UserMessage(content: messages[index].content);
                      }

                      return AssistantMessage(content: message.content);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 24);
                    },
                    itemCount: messages.length,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppColors.dark1),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
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
                    controller: textController,
                    style: TextStyle(
                      color: AppColors.neutralOffWhite,
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
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
                    ),
                    minLines: 1,
                    maxLines: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        child: ValueListenableBuilder(
                          valueListenable: textController,

                          builder: (context, value, child) {
                            return TextButton(
                              onPressed:
                                  textController.text == ''
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
                                  textController.text == ''
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
