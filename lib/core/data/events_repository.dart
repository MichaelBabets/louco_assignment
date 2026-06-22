import '../models/event.dart';
import 'events_data_source.dart';

abstract class EventsRepository {
  Future<Event> getFeaturedEvent();

  Future<List<Event>> getTodayEvents();

  Future<List<Event>> getDiscoverEvents();
}

class EventsRepositoryImpl implements EventsRepository {
  EventsRepositoryImpl({EventsDataSource? dataSource})
    : _dataSource = dataSource ?? MockEventsDataSource();

  final EventsDataSource _dataSource;

  @override
  Future<Event> getFeaturedEvent() => _dataSource.getFeaturedEvent();

  @override
  Future<List<Event>> getTodayEvents() => _dataSource.getTodayEvents();

  @override
  Future<List<Event>> getDiscoverEvents() => _dataSource.getDiscoverEvents();
}

class MockEventsRepository extends EventsRepositoryImpl {
  MockEventsRepository() : super(dataSource: MockEventsDataSource());
}
