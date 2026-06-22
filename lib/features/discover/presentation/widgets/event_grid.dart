import 'package:flutter/material.dart';

import '../../../../../core/models/event.dart';
import '../../../../../core/widgets/event_card.dart';

class EventGrid extends StatelessWidget {
  const EventGrid({super.key, required this.events, required this.onEventTap});

  final List<Event> events;
  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.58,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(event: event, onTap: () => onEventTap(event));
      },
    );
  }
}
