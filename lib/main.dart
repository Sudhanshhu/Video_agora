import 'dart:async';
import 'package:ecommerce/src/home/presentation/bloc/home_bloc.dart';
import 'package:ecommerce/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/dependency_injection.dart';
import 'src/auth/presentation/bloc/auth_bloc.dart';
import 'src/call/views/bloc/call_bloc.dart';
import 'src/on_boarding/presentation/cubit/on_boarding_cubit.dart';

void main() async {
  runZonedGuarded(() async {
    // Initialize bindings and shared preferences inside the same zone
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await setupDependencies();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };

    runApp(const MyApp());
  }, (error, stackTrace) {
    debugPrint('Error: $error\nStackTrace: $stackTrace');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool _showPerformanceOverlay = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingCubit>(
          create: (context) => sl<OnBoardingCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => sl<HomeBloc>(),
        ),
      ],
      child: BlocProvider(
        create: (context) => CallBloc(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: _showPerformanceOverlay,
            title: 'Sales Bets',
            theme: ThemeData.dark(),
            home: const OnBoardingScreen()),
      ),
    );
  }
}
