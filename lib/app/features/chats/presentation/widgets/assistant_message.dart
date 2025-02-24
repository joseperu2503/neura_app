import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';

class AssistantMessage extends StatelessWidget {
  const AssistantMessage({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return GptMarkdown(
      content,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.white,
        height: 1.5,
        leadingDistribution: TextLeadingDistribution.even,
      ),
    );
  }
}
