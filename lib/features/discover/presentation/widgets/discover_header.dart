import 'package:flutter/material.dart';
import '../../../../../core/extensions/build_context_ext.dart';
import '../../../../../core/theme/app_theme.dart';

class DiscoverHeader extends StatelessWidget {
  const DiscoverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.discoverTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset('assets/icons/ic_louco_logo.png', width: 28, height: 28),
        ],
      ),
    );
  }
}
