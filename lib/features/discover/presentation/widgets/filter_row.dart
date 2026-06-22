import 'package:flutter/material.dart';

import '../../../../../core/extensions/build_context_ext.dart';
import '../../../../../core/theme/app_theme.dart';

class FilterRow extends StatelessWidget {
  const FilterRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterTap,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterTap;

  @override
  Widget build(BuildContext context) {
    final filters = [
      context.l10n.discoverFilterDate,
      context.l10n.discoverFilterCategory,
      context.l10n.discoverFilterCity,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          ...filters.map(
            (f) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: f,
                isSelected: selectedFilter == f,
                onTap: () => onFilterTap(f),
              ),
            ),
          ),
          const Spacer(),
          Text(
            context.l10n.discoverFreeOnly,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          const _FreeOnlyToggle(),
        ],
      ),
    );
  }
}

class _FreeOnlyToggle extends StatelessWidget {
  const _FreeOnlyToggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: AppColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
