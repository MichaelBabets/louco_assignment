import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/event.dart';
import '../../../../core/theme/app_theme.dart';
import '../../bloc/ai_chat_bloc.dart';
import 'chat_bubble.dart';
import 'event_results_grid.dart';
import 'suggested_prompts.dart';
import 'typing_indicator.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key, required this.onEventTap});

  final ValueChanged<Event> onEventTap;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiChatBloc, AiChatState>(
      listener: (_, _) => _scrollToBottom(),
      builder: (context, state) {
        final showSuggested = state.messages.length == 1;

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            ...state.messages.map(
              (msg) =>
                  _MessageItem(message: msg, onEventTap: widget.onEventTap),
            ),
            if (state.isTyping) const TypingIndicator(),
            if (showSuggested)
              SuggestedPrompts(
                onPromptSelected: (prompt) {
                  context.read<AiChatBloc>().add(SendMessageEvent(prompt));
                  _scrollToBottom();
                },
              ),
          ],
        );
      },
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message, required this.onEventTap});

  final ChatMessage message;
  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    if (message.isEmptyResponse) {
      return _EmptyResponseRetry(message: message);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatBubble(message: message),
        if (message.events != null && message.events!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EventResultsGrid(
              events: message.events!,
              onEventTap: onEventTap,
              onFavorite: (id) =>
                  context.read<AiChatBloc>().add(ToggleFavoriteEvent(id)),
            ),
          ),
      ],
    );
  }
}

class _EmptyResponseRetry extends StatelessWidget {
  const _EmptyResponseRetry({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context
            .read<AiChatBloc>()
            .add(RetryEmptyResponseEvent(message.id)),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh, color: AppColors.textMuted, size: 14),
            SizedBox(width: 6),
            Text(
              'No response received. Tap to retry.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
