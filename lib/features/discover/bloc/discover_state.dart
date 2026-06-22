part of 'discover_cubit.dart';

sealed class DiscoverState {
  const DiscoverState();
}

class DiscoverInitial extends DiscoverState {
  const DiscoverInitial();
}

class DiscoverLoading extends DiscoverState {
  const DiscoverLoading();
}

class DiscoverLoaded extends DiscoverState {
  const DiscoverLoaded({required this.events});

  final List<Event> events;
}

class DiscoverError extends DiscoverState {
  const DiscoverError(this.message);

  final String message;
}
