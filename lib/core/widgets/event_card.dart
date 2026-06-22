import 'package:flutter/material.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';
import '../utils/date_time_formatter.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    super.key,
    this.onTap,
    this.onFavorite,
  });

  final Event event;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EventCardImage(event: event, onFavorite: onFavorite),
          const SizedBox(height: 8),
          _EventCardInfo(event: event),
        ],
      ),
    );
  }
}

class _EventCardImage extends StatelessWidget {
  const _EventCardImage({required this.event, this.onFavorite});

  final Event event;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _EventNetworkImage(imageUrl: event.imageUrl),
            const _CardGradientOverlay(),
            Positioned(
              top: 8,
              left: 8,
              child: _EventTimeBadge(dateTime: event.dateTime),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: _EventCategoryBadge(category: event.category),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _FavoriteButton(
                isFavorited: event.isFavorited,
                onTap: onFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventNetworkImage extends StatelessWidget {
  const _EventNetworkImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _ImagePlaceholder(),
      );
    }
    return const _ImagePlaceholder();
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceElevated,
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.textMuted, size: 32),
      ),
    );
  }
}

class _CardGradientOverlay extends StatelessWidget {
  const _CardGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
          stops: const [0.5, 1.0],
        ),
      ),
    );
  }
}

class _EventTimeBadge extends StatelessWidget {
  const _EventTimeBadge({required this.dateTime});

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return _OverlayBadge(
      child: Text(
        DateTimeFormatter.eventShortDate(dateTime),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EventCategoryBadge extends StatelessWidget {
  const _EventCategoryBadge({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return _OverlayBadge(
      child: Text(
        category,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorited, this.onTap});

  final bool isFavorited;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          color: isFavorited ? Colors.red : AppColors.textPrimary,
          size: 14,
        ),
      ),
    );
  }
}

class _EventCardInfo extends StatelessWidget {
  const _EventCardInfo({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        _EventLocationRow(venue: event.venue, city: event.city),
      ],
    );
  }
}

class _EventLocationRow extends StatelessWidget {
  const _EventLocationRow({required this.venue, required this.city});

  final String venue;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 11,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            '$venue · $city',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
