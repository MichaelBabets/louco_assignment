import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/models/event.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_time_formatter.dart';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({super.key, required this.event, required this.onTap});

  final Event event;
  final VoidCallback onTap;

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 400,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _FeaturedImage(imageUrl: widget.event.imageUrl),
            const _FeaturedGradient(),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: _DateBadge(dateTime: widget.event.dateTime),
            ),
            Positioned(
              right: 12,
              top: 0,
              bottom: 100,
              child: _FeaturedActions(
                isFavorited: _isFavorited,
                onFavoriteTap: () =>
                    setState(() => _isFavorited = !_isFavorited),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 60,
              child: _FeaturedInfo(
                event: widget.event,
                onMoreInfosTap: widget.onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedImage extends StatelessWidget {
  const _FeaturedImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _FeaturedPlaceholder(),
      );
    }
    return const _FeaturedPlaceholder();
  }
}

class _FeaturedPlaceholder extends StatelessWidget {
  const _FeaturedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceElevated,
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.textMuted, size: 48),
      ),
    );
  }
}

class _FeaturedGradient extends StatelessWidget {
  const _FeaturedGradient();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.3),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.dateTime});

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            DateTimeFormatter.monthAbbr(dateTime),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            DateTimeFormatter.dayNumber(dateTime),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedActions extends StatelessWidget {
  const _FeaturedActions({
    required this.isFavorited,
    required this.onFavoriteTap,
  });

  final bool isFavorited;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _CircleActionButton(
          icon: isFavorited ? Icons.favorite : Icons.favorite_border,
          color: isFavorited ? Colors.red : AppColors.textPrimary,
          onTap: onFavoriteTap,
        ),
        const SizedBox(height: 16),
        _CircleActionButton(icon: Icons.share_outlined, onTap: () {}),
        const SizedBox(height: 16),
        _CircleActionButton(icon: Icons.volume_off_outlined, onTap: () {}),
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    this.color = AppColors.textPrimary,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class _FeaturedInfo extends StatelessWidget {
  const _FeaturedInfo({required this.event, required this.onMoreInfosTap});

  final Event event;
  final VoidCallback onMoreInfosTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${event.category}, ${event.venue}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ActionPill(
              icon: Icons.confirmation_number_outlined,
              label: context.l10n.homeBuyTicket,
              isPrimary: true,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionPill(
              icon: Icons.info_outline,
              label: context.l10n.homeMoreInfos,
              isPrimary: false,
              onTap: onMoreInfosTap,
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _PageIndicator(totalDots: 6, activeDotIndex: 5),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isPrimary
              ? null
              : Border.all(color: AppColors.textPrimary.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isPrimary ? Colors.black : AppColors.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.black : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.totalDots, required this.activeDotIndex});

  final int totalDots;
  final int activeDotIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalDots, (i) {
        final isActive = i == activeDotIndex;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: isActive ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : AppColors.textMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
