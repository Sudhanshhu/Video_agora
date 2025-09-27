import 'package:flutter/material.dart';

class ErrorViewWithScaffold extends StatelessWidget {
  const ErrorViewWithScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ErrorView());
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error'),
    );
  }
}
