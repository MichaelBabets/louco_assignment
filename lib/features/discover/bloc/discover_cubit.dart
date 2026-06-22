import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/events_repository.dart';
import '../../../core/models/event.dart';

part 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit({EventsRepository? repository})
    : _repository = repository ?? MockEventsRepository(),
      super(const DiscoverInitial()) {
    loadData();
  }

  final EventsRepository _repository;

  Future<void> loadData() async {
    emit(const DiscoverLoading());
    try {
      final events = await _repository.getDiscoverEvents();
      emit(DiscoverLoaded(events: events));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }
}
