import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   HomeBloc() : super(HomeInitial()) {
//     on<HomeEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<CreateEventEvent>(_onCreateEvent);
    on<IncreaseCreditsEvent>(_onIncreaseCredits);
    on<ListenStreamingStatusEvent>(_onListenStreamingStatus);
  }

  void _onLoadEvents(LoadEventsEvent event, Emitter<HomeState> emit) {
    emit(HomeLoading());
    repository.getEventsStream().listen((events) {
      add(ListenStreamingStatusEvent());
      emit(HomeLoaded(events));
    });
  }

  void _onCreateEvent(CreateEventEvent event, Emitter<HomeState> emit) async {
    await repository.createEvent(
        event.title, event.description, event.startTime, event.userId);
  }

  void _onIncreaseCredits(
      IncreaseCreditsEvent event, Emitter<HomeState> emit) async {
    await repository.increaseCredits(event.userId, event.amount);
  }

  void _onListenStreamingStatus(
      ListenStreamingStatusEvent event, Emitter<HomeState> emit) {
    repository.listenToStreamingStatus().listen((isStreaming) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeLoaded(currentState.events, isStreamingActive: isStreaming));
      }
    });
  }
}
