import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/repositories/chat_repository.dart';
import 'package:neura_app/app/features/chats/presentation/functions/show_assistant_message_menu.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/feedback_bottom_sheet.dart';
import 'package:neura_app/service_locator.dart';

class AssistantMessage extends StatefulWidget {
  const AssistantMessage({
    super.key,
    required this.message,
    required this.chatId,
  });

  final Message message;
  final String chatId;

  @override
  State<AssistantMessage> createState() => _AssistantMessageState();
}

class _AssistantMessageState extends State<AssistantMessage> {
  final ChatRepository _repository = sl<ChatRepository>();

  openDislikeModal(BuildContext context) async {
    final String feedback = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return const FeedbackBottomSheet();
      },
    );

    _repository.disapproveMessage(
      chatId: widget.chatId,
      messageId: widget.message.id,
      reason: feedback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) async {
        showAssistanMessageMenu(
          context: context,
          position: details.globalPosition,
          goodResponse: () {},
          badResponse: () {
            openDislikeModal(context);
          },
        );
      },
      child: GptMarkdown(
        widget.message.content,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
          height: 1.5,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
    );
  }
}
