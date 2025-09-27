part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<EventEntity> events;
  final bool isStreamingActive;
  const HomeLoaded(this.events, {this.isStreamingActive = false});
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
