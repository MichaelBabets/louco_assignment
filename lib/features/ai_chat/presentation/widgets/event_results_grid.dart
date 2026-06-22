import 'package:flutter/material.dart';
import '../../../../core/models/event.dart';
import '../../../../core/widgets/event_card.dart';
import '../../../../core/theme/app_theme.dart';

class EventResultsGrid extends StatelessWidget {
  const EventResultsGrid({
    required this.events,
    required this.onEventTap,
    required this.onFavorite,
    super.key,
  });

  final List<Event> events;
  final ValueChanged<Event> onEventTap;
  final ValueChanged<String> onFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12, top: 4),
          child: Text(
            'Event Results:',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return EventCard(
              event: event,
              onTap: () => onEventTap(event),
              onFavorite: () => onFavorite(event.id),
            );
          },
        ),
      ],
    );
  }
}
