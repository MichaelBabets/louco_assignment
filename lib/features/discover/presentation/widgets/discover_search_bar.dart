import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/build_context_ext.dart';
import '../../../../../core/theme/app_theme.dart';

class DiscoverSearchBar extends StatelessWidget {
  const DiscoverSearchBar({super.key, required this.onAskAiTap});

  final VoidCallback onAskAiTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          const Expanded(child: _SearchTextField()),
          const SizedBox(width: 8),
          _AskAiButton(onTap: onAskAiTap),
        ],
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          SvgPicture.asset(
            'assets/icons/search.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.textMuted,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.discoverSearchHint,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AskAiButton extends StatelessWidget {
  const _AskAiButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.69, -0.72),
            end: Alignment(0.69, 0.72),
            colors: [AppColors.askAiGradientStart, AppColors.askAiGradientEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.askAiGradientStart.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.askAiGradientStart.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_ai_sparkle.svg',
              width: 13,
              height: 13,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.discoverAskAi,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
