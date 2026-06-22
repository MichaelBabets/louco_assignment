import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/models/event.dart';
import '../../../../core/theme/app_theme.dart';
import '../../bloc/ai_chat_bloc.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_sheet_header.dart';
import '../widgets/message_list.dart';

/// Self-contained bottom sheet.
///
/// Usage:
/// ```dart
/// showModalBottomSheet(
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => AiChatBottomSheet(onEventTap: ...),
/// );
/// ```
class AiChatBottomSheet extends StatelessWidget {
  const AiChatBottomSheet({super.key, required this.onEventTap});

  final ValueChanged<Event> onEventTap;

  static const _defaultHeightRatio = 0.82;

  @override
  Widget build(BuildContext context) {
    final greetingText = context.l10n.aiChatGreeting;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final view = View.of(context);
    final topPadding = view.padding.top / view.devicePixelRatio;

    final sheetHeight = keyboardHeight > 0
        ? screenHeight - topPadding
        : screenHeight * _defaultHeightRatio;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: sheetHeight,
      child: BlocProvider(
        create: (_) => AiChatBloc(greetingText: greetingText),
        child: _SheetContent(onEventTap: onEventTap),
      ),
    );
  }
}

class _SheetContent extends StatelessWidget {
  const _SheetContent({required this.onEventTap});

  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const _DragHandle(),
          const ChatSheetHeader(),
          const Divider(color: AppColors.divider, height: 1),
          Flexible(child: MessageList(onEventTap: onEventTap)),
          ChatInput(
            onSubmit: (msg) =>
                context.read<AiChatBloc>().add(SendMessageEvent(msg)),
          ),
          SizedBox(height: keyboardHeight),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textMuted.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
