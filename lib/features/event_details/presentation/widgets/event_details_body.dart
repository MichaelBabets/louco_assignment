import 'package:flutter/material.dart';

import '../../../../../core/extensions/build_context_ext.dart';
import '../../../../../core/models/event.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_time_formatter.dart';

class EventDetailsBody extends StatelessWidget {
  const EventDetailsBody({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EventTitleSection(event: event),
          const SizedBox(height: 20),
          _EventInfoTile(
            icon: Icons.calendar_today_outlined,
            title: DateTimeFormatter.eventDetailsFull(event.dateTime),
            subtitle: context.l10n.homeMarkCalendar,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _EventInfoTile(
            icon: Icons.location_on_outlined,
            title: context.l10n.eventDetailsVenueName,
            subtitle: context.l10n.eventDetailsVenueAddress,
            onTap: () {},
            hasArrow: true,
          ),
          const SizedBox(height: 32),
          _ArtistSection(event: event),
        ],
      ),
    );
  }
}

class _EventTitleSection extends StatelessWidget {
  const _EventTitleSection({required this.event});

  final Event event;

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
          '${event.category} • ${event.city}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

class _EventInfoTile extends StatelessWidget {
  const _EventInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.hasArrow = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool hasArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoTileIcon(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: _InfoTileText(title: title, subtitle: subtitle),
          ),
          if (hasArrow)
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textMuted,
              size: 14,
            ),
        ],
      ),
    );
  }
}

class _InfoTileIcon extends StatelessWidget {
  const _InfoTileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 18),
    );
  }
}

class _InfoTileText extends StatelessWidget {
  const _InfoTileText({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _ArtistSection extends StatelessWidget {
  const _ArtistSection({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${event.category} •\n${event.city}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
