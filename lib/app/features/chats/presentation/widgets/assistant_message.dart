import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/app/features/chats/presentation/functions/show_assistant_message_menu.dart';

class AssistantMessage extends StatefulWidget {
  const AssistantMessage({super.key, required this.content});

  final String content;

  @override
  State<AssistantMessage> createState() => _AssistantMessageState();
}

class _AssistantMessageState extends State<AssistantMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) async {
        showAssistanMessageMenu(
          context: context,
          position: details.globalPosition,
          goodResponse: () {},
          badResponse: () {},
        );
      },
      child: GptMarkdown(
        widget.content,
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
