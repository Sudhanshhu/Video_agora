import 'package:ecommerce/src/home/data/repositories/home_repository_impl.dart';
import 'package:ecommerce/src/home/domain/repositories/home_repository.dart';
import 'package:ecommerce/src/home/presentation/bloc/home_bloc.dart';
import 'package:ecommerce/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';

import '../../src/auth/data/repositories/auth_repository_impl.dart';
import '../../src/auth/domain/repositories/auth_repository.dart';
import '../../src/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  sl.registerFactory(() => OnBoardingCubit());
  sl.registerFactory(() => AuthBloc(sl<AuthRepository>()));
  sl.registerFactory(() => HomeBloc(sl<HomeRepository>()));
}
