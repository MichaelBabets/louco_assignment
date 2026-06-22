import '../models/event.dart';

abstract class EventsDataSource {
  Future<Event> getFeaturedEvent();

  Future<List<Event>> getTodayEvents();

  Future<List<Event>> getDiscoverEvents();
}

class MockEventsDataSource implements EventsDataSource {
  @override
  Future<Event> getFeaturedEvent() async => _kFeaturedEvent;

  @override
  Future<List<Event>> getTodayEvents() async => _kTodayEvents;

  @override
  Future<List<Event>> getDiscoverEvents() async => _kDiscoverEvents;
}

// Mock data
final _kFeaturedEvent = Event(
  id: 'featured_1',
  title: 'Ayliva',
  category: 'Party',
  venue: "Cooky's Frankfurt",
  city: 'Frankfurt',
  dateTime: DateTime(2026, 1, 10, 22, 0),
  imageUrl:
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
);

final _kTodayEvents = [
  Event(
    id: 'h1',
    title: 'Best of Oper - Carmen',
    category: 'Concerts & Festivals',
    venue: 'Alte Oper',
    city: 'Frankfurt',
    dateTime: DateTime(2026, 6, 17, 19, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
  ),
  Event(
    id: 'h2',
    title: 'Jazz Night Live',
    category: 'Concerts & Festivals',
    venue: 'Blue Note',
    city: 'Frankfurt',
    dateTime: DateTime(2026, 6, 17, 21, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?w=400',
  ),
  Event(
    id: 'h3',
    title: 'Techno Underground',
    category: 'Party & Nightlife',
    venue: 'Club Culture',
    city: 'Frankfurt',
    dateTime: DateTime(2026, 6, 17, 23, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1598387846148-47e82ee120cc?w=400',
  ),
  Event(
    id: 'h4',
    title: 'Indie Rock Fest',
    category: 'Concerts & Festivals',
    venue: 'Main Arena',
    city: 'Frankfurt',
    dateTime: DateTime(2026, 6, 17, 17, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
  ),
];

final _kDiscoverEvents = [
  Event(
    id: 'd1',
    title: 'Best of Oper - Carmen',
    category: 'Concerts & Festivals',
    venue: 'Alte Oper Frankfurt',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 15, 19, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
  ),
  Event(
    id: 'd2',
    title: 'Jazz Night Live',
    category: 'Concerts & Festivals',
    venue: 'Blue Note Club',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 15, 21, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?w=400',
  ),
  Event(
    id: 'd3',
    title: 'Techno Underground',
    category: 'Party & Nightlife',
    venue: 'Berghain Frankfurt',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 15, 23, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1598387846148-47e82ee120cc?w=400',
  ),
  Event(
    id: 'd4',
    title: 'Indie Rock Fest',
    category: 'Concerts & Festivals',
    venue: 'Main Arena',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 17, 17, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
  ),
  Event(
    id: 'd5',
    title: 'Summer Vibes',
    category: 'Party & Nightlife',
    venue: 'Gaia Rooftop',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 18, 20, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400',
  ),
  Event(
    id: 'd6',
    title: 'Art Exhibition Night',
    category: 'Arts & Culture',
    venue: 'Städel Museum',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 19, 19, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1501699169021-3759ee435d66?w=400',
    isFree: true,
  ),
  Event(
    id: 'd7',
    title: 'Food & Wine Festival',
    category: 'Food & Drink',
    venue: 'Römerberg',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 20, 12, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
  ),
  Event(
    id: 'd8',
    title: 'Electronic Beats',
    category: 'Party & Nightlife',
    venue: 'Club Culture',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 22, 22, 0),
    imageUrl:
        'https://images.unsplash.com/photo-1571266028243-e4733b0f0bb0?w=400',
  ),
];
