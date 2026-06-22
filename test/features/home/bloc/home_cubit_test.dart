import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:louco_assignment/core/models/event.dart';
import 'package:louco_assignment/core/data/events_repository.dart';
import 'package:louco_assignment/features/home/bloc/home_cubit.dart';

// ---------------------------------------------------------------------------
// Fake repositories
// ---------------------------------------------------------------------------

final _featuredEvent = Event(
  id: 'featured_1',
  title: 'Featured Event',
  category: 'Music',
  venue: 'Main Stage',
  city: 'Frankfurt',
  dateTime: DateTime(2025, 8, 1, 20, 0),
);

final _todayEvents = [
  Event(
    id: 'today_1',
    title: 'Today Event 1',
    category: 'Art',
    venue: 'Gallery',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 1, 18, 0),
  ),
  Event(
    id: 'today_2',
    title: 'Today Event 2',
    category: 'Food',
    venue: 'Market',
    city: 'Frankfurt',
    dateTime: DateTime(2025, 8, 1, 19, 0),
  ),
];

class _SuccessRepository implements EventsRepository {
  const _SuccessRepository();

  @override
  Future<Event> getFeaturedEvent() async => _featuredEvent;

  @override
  Future<List<Event>> getTodayEvents() async => _todayEvents;

  @override
  Future<List<Event>> getDiscoverEvents() async => [];
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

class _FeaturedErrorRepository implements EventsRepository {
  const _FeaturedErrorRepository();

  @override
  Future<Event> getFeaturedEvent() async => throw Exception('Featured failed');

  @override
  Future<List<Event>> getTodayEvents() async => _todayEvents;

  @override
  Future<List<Event>> getDiscoverEvents() async => [];
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('HomeCubit', () {
    // Note: HomeCubit calls loadData() in the constructor. The first
    // emit(HomeLoading()) is synchronous and fires before blocTest starts
    // listening, so only the subsequent async emit is captured.

    blocTest<HomeCubit, HomeState>(
      'emits HomeLoaded with correct data on success',
      build: () => HomeCubit(repository: const _SuccessRepository()),
      expect: () => [
        predicate<HomeLoaded>(
          (s) =>
              s.featuredEvent == _featuredEvent &&
              s.todayEvents.length == 2 &&
              s.todayEvents.first.id == 'today_1',
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits HomeError when repository throws',
      build: () => HomeCubit(repository: const _ErrorRepository()),
      expect: () => [isA<HomeError>()],
    );

    blocTest<HomeCubit, HomeState>(
      'HomeError contains the exception message',
      build: () => HomeCubit(repository: const _FeaturedErrorRepository()),
      expect: () => [
        predicate<HomeError>((s) => s.message.contains('Featured failed')),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'loadData re-emits [HomeLoading, HomeLoaded] when called again',
      build: () => HomeCubit(repository: const _SuccessRepository()),
      // Wait for the constructor-triggered load to complete first.
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.loadData();
      },
      expect: () => [
        // Constructor load: HomeLoading missed (sync), HomeLoaded captured.
        isA<HomeLoaded>(),
        // Manual reload: both states captured.
        isA<HomeLoading>(),
        isA<HomeLoaded>(),
      ],
    );

    test(
      'loaded state exposes correct featuredEvent and todayEvents',
      () async {
        final cubit = HomeCubit(repository: const _SuccessRepository());
        await Future<void>.delayed(Duration.zero);
        final state = cubit.state as HomeLoaded;
        expect(state.featuredEvent.id, 'featured_1');
        expect(
          state.todayEvents.map((e) => e.id),
          containsAll(['today_1', 'today_2']),
        );
        await cubit.close();
      },
    );
  });
}
