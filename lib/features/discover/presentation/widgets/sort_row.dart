import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context_ext.dart';
import '../../../../../core/theme/app_theme.dart';

class SortRow extends StatelessWidget {
  const SortRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          _SortChip(label: context.l10n.discoverSort),
          const SizedBox(width: 8),
          const _GridToggleButton(
            iconPath: 'assets/icons/two_columns.svg',
            isSelected: true,
          ),
          const SizedBox(width: 8),
          const _GridToggleButton(
            iconPath: 'assets/icons/three_columns.svg',
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/sorting.svg',
            width: 13,
            height: 13,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _GridToggleButton extends StatelessWidget {
  const _GridToggleButton({required this.iconPath, required this.isSelected});

  final String iconPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 32,
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
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          iconPath,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            isSelected ? AppColors.primary : AppColors.textMuted,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
