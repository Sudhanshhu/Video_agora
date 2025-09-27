part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadEventsEvent extends HomeEvent {}

class CreateEventEvent extends HomeEvent {
  final String title;
  final String description;
  final DateTime startTime;
  final String userId;
  const CreateEventEvent(
      this.title, this.description, this.startTime, this.userId);
}

class IncreaseCreditsEvent extends HomeEvent {
  final String userId;
  final int amount;
  const IncreaseCreditsEvent(this.userId, this.amount);
}

class ListenStreamingStatusEvent extends HomeEvent {}
