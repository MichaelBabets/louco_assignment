import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/models/event.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/event_card.dart';

class TodaySection extends StatelessWidget {
  const TodaySection({
    super.key,
    required this.events,
    required this.onEventTap,
  });

  final List<Event> events;
  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TodaySectionHeader(city: 'Frankfurt'),
        _TodayEventsList(events: events, onEventTap: onEventTap),
      ],
    );
  }
}

class _TodaySectionHeader extends StatelessWidget {
  const _TodaySectionHeader({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Text(
            context.l10n.homeToday,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            context.l10n.homeInCity(city),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Text(
              context.l10n.homeSeeAll,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayEventsList extends StatelessWidget {
  const _TodayEventsList({required this.events, required this.onEventTap});

  final List<Event> events;
  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: EdgeInsets.only(right: index < events.length - 1 ? 12 : 0),
            child: SizedBox(
              width: 144,
              child: EventCard(event: event, onTap: () => onEventTap(event)),
            ),
          );
        },
      ),
    );
  }
}
