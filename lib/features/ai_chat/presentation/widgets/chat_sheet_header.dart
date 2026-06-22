import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_theme.dart';

class ChatSheetHeader extends StatelessWidget {
  const ChatSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const _AiAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.aiChatTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  context.l10n.aiChatSubtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _CloseButton(onTap: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SvgPicture.asset(
          'assets/icons/ic_ai_sparkle.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.chipBackground,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: AppColors.textPrimary, size: 16),
      ),
    );
  }
}
