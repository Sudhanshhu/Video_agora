import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/on_boarding_local_data_source.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(const OnBoardingInitial());

  OnBoardingLocalDataSrcImpl localDataSource =
      const OnBoardingLocalDataSrcImpl();

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    await localDataSource.cacheFirstTimer();
    emit(const UserCached());
  }

  Future<void> checkIfUserIsFirstTimer() async {
    emit(const CheckingIfUserIsFirstTimer());
    final result = await localDataSource.checkIfUserIsFirstTimer();
    if (result.success) {
      emit(OnBoardingStatus(isFirstTimer: result.data ?? false));
    } else {
      emit(const OnBoardingStatus(isFirstTimer: true));
    }
  }
}
