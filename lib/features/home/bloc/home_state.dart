part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  const HomeLoaded({required this.featuredEvent, required this.todayEvents});

  final Event featuredEvent;
  final List<Event> todayEvents;

  @override
  List<Object?> get props => [featuredEvent, todayEvents];
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
