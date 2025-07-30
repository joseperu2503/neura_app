import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/app/features/chats/domain/entities/message.entity.dart';
import 'package:neura_app/app/features/chats/domain/models/feedback_type.dart';
import 'package:neura_app/app/features/chats/presentation/blocs/chat/chat_cubit.dart';
import 'package:neura_app/app/features/chats/presentation/functions/show_assistant_message_menu.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/feedback_bottom_sheet.dart';

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
  _disapproveMessage() async {
    final chatCubit = context.read<ChatCubit>();

    if (widget.message.feedbackType == FeedbackType.bad) {
      chatCubit.feedbackMessage(
        chatId: widget.chatId,
        messageId: widget.message.id,
        feedbackType: null,
        description: "",
      );
    } else {
      final String feedbackDescription = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return const FeedbackBottomSheet();
        },
      );
      chatCubit.feedbackMessage(
        chatId: widget.chatId,
        messageId: widget.message.id,
        feedbackType: FeedbackType.bad,
        description: feedbackDescription,
      );
    }
  }

  _approveMessage() async {
    final chatCubit = context.read<ChatCubit>();
    final feedbackType =
        widget.message.feedbackType == FeedbackType.good
            ? null
            : FeedbackType.good;

    chatCubit.feedbackMessage(
      chatId: widget.chatId,
      messageId: widget.message.id,
      feedbackType: feedbackType,
      description: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) async {
        showAssistanMessageMenu(
          context: context,
          position: details.globalPosition,
          message: widget.message,
          goodResponse: () {
            _approveMessage();
          },
          badResponse: () {
            _disapproveMessage();
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GptMarkdown(
            widget.message.content,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
              height: 1.5,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: TextButton(
                  onPressed: () {
                    _approveMessage();
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Center(
                    child: SvgPicture.asset(
                      widget.message.feedbackType == FeedbackType.good
                          ? "assets/icons/like-solid.svg"
                          : "assets/icons/like.svg",
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 32,
                height: 32,
                child: TextButton(
                  onPressed: () {
                    _disapproveMessage();
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Center(
                    child: SvgPicture.asset(
                      widget.message.feedbackType == FeedbackType.bad
                          ? "assets/icons/dislike-solid.svg"
                          : "assets/icons/dislike.svg",
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
