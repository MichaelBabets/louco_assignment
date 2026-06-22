import 'dart:math';

import '../../../core/models/event.dart';
import 'ai_chat_repository.dart';

abstract class AiChatDataSource {
  Future<AiResponse> sendMessage(String message);
}

/// Mock data source that simulates network behaviour:
/// - 1st call: success
/// - 2nd call: throws (simulates a transient network error)
/// - 3rd call: success again
/// - 4th call: returns an empty response (simulates an empty/unrecognised reply)
/// - 5th+ calls: success again
class MockAiChatDataSource implements AiChatDataSource {
  MockAiChatDataSource({int initialCallCount = 0})
    : _callCount = initialCallCount;

  int _callCount;

  @override
  Future<AiResponse> sendMessage(String message) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    _callCount++;
    if (_callCount == 2) {
      throw Exception('Network error. Please try again.');
    }
    if (_callCount == 4) {
      return const AiResponse(text: '', events: []);
    }
    return AiResponse(
      text: _responseText(message),
      events: _responseEvents(message),
    );
  }

  static String _responseText(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('tonight') || lower.contains('today')) {
      return 'Here are the events happening tonight in Frankfurt';
    }
    if (lower.contains('near me') || lower.contains('nearby')) {
      return 'Here are events near your location';
    }
    if (lower.contains('join') || lower.contains('someone')) {
      return 'Here are some social events where you can meet people';
    }
    if (lower.contains('pop') || lower.contains('music')) {
      return 'Here are upcoming music events in Frankfurt';
    }
    if (lower.contains('free')) {
      return 'Here are free events happening near you';
    }
    return 'Here are some great events I found for you';
  }

  static List<Event> _responseEvents(String message) {
    final lower = message.toLowerCase();
    final now = DateTime.now();
    final all = _buildEventPool(now);

    if (lower.contains('free')) {
      return all.where((e) => e.isFree).toList();
    }
    if (lower.contains('pop') ||
        lower.contains('music') ||
        lower.contains('concert')) {
      return all
          .where(
            (e) =>
                e.category.toLowerCase().contains('music') ||
                e.category.toLowerCase().contains('concert'),
          )
          .toList();
    }
    if (lower.contains('join') || lower.contains('social')) {
      return all
          .where(
            (e) =>
                e.category.toLowerCase().contains('party') ||
                e.category.toLowerCase().contains('nightlife'),
          )
          .toList();
    }

    final shuffled = List<Event>.from(all)..shuffle(Random(42));
    return shuffled.take(min(4, shuffled.length)).toList();
  }

  static List<Event> _buildEventPool(DateTime now) => [
    Event(
      id: 'r1',
      title: 'Summer Beach Party',
      category: 'Party',
      venue: 'Gaia Rooftop',
      city: 'Frankfurt',
      dateTime: now.copyWith(hour: 18, minute: 0),
      imageUrl:
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400',
    ),
    Event(
      id: 'r2',
      title: 'Summer Beach Party',
      category: 'Party',
      venue: 'Gaia Rooftop',
      city: 'Frankfurt',
      dateTime: now.copyWith(hour: 21, minute: 0),
      imageUrl:
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400',
    ),
    Event(
      id: 'r3',
      title: 'Techno Underground',
      category: 'Nightlife',
      venue: 'Berghain Club',
      city: 'Frankfurt',
      dateTime: now.copyWith(hour: 22, minute: 0),
      imageUrl:
          'https://images.unsplash.com/photo-1598387846148-47e82ee120cc?w=400',
    ),
    Event(
      id: 'r4',
      title: 'Jazz Night Live',
      category: 'Music',
      venue: 'Jazz Cafe',
      city: 'Frankfurt',
      dateTime: now.copyWith(hour: 20, minute: 30),
      imageUrl:
          'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?w=400',
    ),
    Event(
      id: 'r5',
      title: 'Ayliva Concert',
      category: 'Concerts',
      venue: "Cooky's Frankfurt",
      city: 'Frankfurt',
      dateTime: DateTime(now.year, 7, 25, 22, 0),
      imageUrl:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
    ),
    Event(
      id: 'r6',
      title: 'Art Exhibition Night',
      category: 'Arts',
      venue: 'Städel Museum',
      city: 'Frankfurt',
      dateTime: now.add(const Duration(days: 1)).copyWith(hour: 19, minute: 0),
      imageUrl:
          'https://images.unsplash.com/photo-1501699169021-3759ee435d66?w=400',
      isFree: true,
    ),
    Event(
      id: 'r7',
      title: 'Food & Wine Festival',
      category: 'Food',
      venue: 'Römerberg',
      city: 'Frankfurt',
      dateTime: now.add(const Duration(days: 3)).copyWith(hour: 12, minute: 0),
      imageUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
    ),
  ];
}
