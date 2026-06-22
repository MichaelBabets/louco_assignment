import 'package:flutter/material.dart';

import '../../../../../core/extensions/build_context_ext.dart';
import '../../../../../core/theme/app_theme.dart';

class ResultsCount extends StatelessWidget {
  const ResultsCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          children: [
            TextSpan(
              text: '$count',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            TextSpan(text: context.l10n.discoverResultsFoundSuffix),
          ],
        ),
      ),
    );
  }
}
