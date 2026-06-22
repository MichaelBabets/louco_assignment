import 'package:flutter/material.dart';

import '../../../../../core/models/event.dart';
import '../../../../../core/theme/app_theme.dart';

class EventHeroAppBar extends StatelessWidget {
  const EventHeroAppBar({
    super.key,
    required this.event,
    required this.isFavorited,
    required this.onFavoriteTap,
  });

  final Event event;
  final bool isFavorited;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 360,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: const _BackButton(),
      actions: [
        _FavoriteAppBarButton(isFavorited: isFavorited, onTap: onFavoriteTap),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _EventHeroImage(imageUrl: event.imageUrl),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.textPrimary,
          size: 16,
        ),
      ),
    );
  }
}

class _FavoriteAppBarButton extends StatelessWidget {
  const _FavoriteAppBarButton({required this.isFavorited, required this.onTap});

  final bool isFavorited;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          color: isFavorited ? Colors.red : AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

class _EventHeroImage extends StatelessWidget {
  const _EventHeroImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _HeroPlaceholder(),
      );
    }
    return const _HeroPlaceholder();
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

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
