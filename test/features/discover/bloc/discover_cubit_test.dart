import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:louco_assignment/core/models/event.dart';
import 'package:louco_assignment/core/data/events_repository.dart';
import 'package:louco_assignment/features/discover/bloc/discover_cubit.dart';

// ---------------------------------------------------------------------------
// Fake repositories
// ---------------------------------------------------------------------------

final _discoverEvents = [
  Event(
    id: 'disc_1',
    title: 'Discover Event 1',
    category: 'Music',
    venue: 'Club',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 1, 21, 0),
  ),
  Event(
    id: 'disc_2',
    title: 'Discover Event 2',
    category: 'Art',
    venue: 'Gallery',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 2, 18, 0),
    isFree: true,
  ),
  Event(
    id: 'disc_3',
    title: 'Discover Event 3',
    category: 'Food',
    venue: 'Market',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 3, 12, 0),
    price: 9.99,
  ),
];

class _SuccessRepository implements EventsRepository {
  const _SuccessRepository({this.events = const []});

  final List<Event> events;

  @override
  Future<Event> getFeaturedEvent() async => _discoverEvents.first;

  @override
  Future<List<Event>> getTodayEvents() async => [];

  @override
  Future<List<Event>> getDiscoverEvents() async => events;
}

class _ErrorRepository implements EventsRepository {
  const _ErrorRepository();

  @override
  Future<Event> getFeaturedEvent() async => throw Exception('Network error');

  @override
  Future<List<Event>> getTodayEvents() async =>
      throw Exception('Network error');

  @override
  Future<List<Event>> getDiscoverEvents() async =>
      throw Exception('Network error');
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('DiscoverCubit', () {
    // Note: DiscoverCubit calls loadData() in the constructor. The first
    // emit(DiscoverLoading()) is synchronous and fires before blocTest starts
    // listening, so only the subsequent async emit is captured.

    blocTest<DiscoverCubit, DiscoverState>(
      'emits DiscoverLoaded with correct events on success',
      build: () => DiscoverCubit(
        repository: _SuccessRepository(events: _discoverEvents),
      ),
      expect: () => [predicate<DiscoverLoaded>((s) => s.events.length == 3)],
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'emits DiscoverLoaded with empty list when repository returns no events',
      build: () =>
          DiscoverCubit(repository: const _SuccessRepository(events: [])),
      expect: () => [predicate<DiscoverLoaded>((s) => s.events.isEmpty)],
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'emits DiscoverError when repository throws',
      build: () => DiscoverCubit(repository: const _ErrorRepository()),
      expect: () => [isA<DiscoverError>()],
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'DiscoverError contains the exception message',
      build: () => DiscoverCubit(repository: const _ErrorRepository()),
      expect: () => [
        predicate<DiscoverError>((s) => s.message.contains('Network error')),
      ],
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'loadData re-emits [DiscoverLoading, DiscoverLoaded] when called again',
      build: () => DiscoverCubit(
        repository: _SuccessRepository(events: _discoverEvents),
      ),
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.loadData();
      },
      expect: () => [
        // Constructor load: DiscoverLoading missed (sync), DiscoverLoaded captured.
        isA<DiscoverLoaded>(),
        // Manual reload: both states captured.
        isA<DiscoverLoading>(),
        isA<DiscoverLoaded>(),
      ],
    );

    test('loaded state exposes correct event properties', () async {
      final cubit = DiscoverCubit(
        repository: _SuccessRepository(events: _discoverEvents),
      );
      await Future<void>.delayed(Duration.zero);
      final state = cubit.state as DiscoverLoaded;
      expect(state.events.map((e) => e.id), ['disc_1', 'disc_2', 'disc_3']);
      expect(state.events[1].isFree, isTrue);
      expect(state.events[2].price, 9.99);
      await cubit.close();
    });
  });
}
