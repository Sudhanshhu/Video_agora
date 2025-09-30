import 'package:ecommerce/src/home/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading, error: null));
    try {
      final response = await repo.fetchUser();
      final List<ApiUser> users = response.data ?? [];
      emit(state.copyWith(users: users, status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
    }
  }
}
