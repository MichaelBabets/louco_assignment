import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/events_repository.dart';
import '../../../core/models/event.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({EventsRepository? repository})
    : _repository = repository ?? MockEventsRepository(),
      super(const HomeInitial()) {
    loadData();
  }

  final EventsRepository _repository;

  Future<void> loadData() async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _repository.getFeaturedEvent(),
        _repository.getTodayEvents(),
      ]);
      emit(
        HomeLoaded(
          featuredEvent: results[0] as Event,
          todayEvents: results[1] as List<Event>,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
