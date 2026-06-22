import 'package:flutter/material.dart';
import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_theme.dart';

class SuggestedPrompts extends StatelessWidget {
  const SuggestedPrompts({super.key, required this.onPromptSelected});

  final ValueChanged<String> onPromptSelected;

  @override
  Widget build(BuildContext context) {
    final prompts = context.l10n.suggestedPrompts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            context.l10n.aiChatSuggestedPromptsLabel,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...prompts.map(
          (prompt) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PromptChip(
              label: prompt,
              onTap: () => onPromptSelected(prompt),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
