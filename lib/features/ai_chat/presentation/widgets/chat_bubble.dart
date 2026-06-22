import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_time_formatter.dart';
import '../../bloc/ai_chat_bloc.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBubbleWidth = constraints.maxWidth * 2 / 3;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    _BubbleBody(
                      text: message.text,
                      isUser: isUser,
                      status: message.status,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateTimeFormatter.chatTimestamp(message.timestamp),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                        if (message.status == MessageStatus.failed) ...[
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => context.read<AiChatBloc>().add(
                              ResendMessageEvent(message.id),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 11,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  context.l10n.aiChatFailedTapToResend,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isUser) const SizedBox(width: 2),
            ],
          ),
        );
      },
    );
  }
}

class _BubbleBody extends StatelessWidget {
  const _BubbleBody({
    required this.text,
    required this.isUser,
    required this.status,
  });

  final String text;
  final bool isUser;
  final MessageStatus status;

  @override
  Widget build(BuildContext context) {
    final isFailed = status == MessageStatus.failed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isFailed
            ? Colors.red.withValues(alpha: 0.15)
            : isUser
            ? AppColors.userBubble
            : AppColors.aiBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
        border: isFailed
            ? Border.all(color: Colors.redAccent.withValues(alpha: 0.4))
            : Border.all(color: const Color(0xFF28292B)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isFailed ? Colors.redAccent : AppColors.textPrimary,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }
}
