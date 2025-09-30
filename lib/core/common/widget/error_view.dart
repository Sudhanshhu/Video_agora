import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/media_res.dart';

class ErrorViewWidget extends StatelessWidget {
  const ErrorViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ErrorView());
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text('Error'),
        ),
        Center(
          child: Lottie.asset(
            MediaRes.error,
            repeat: false,
          ),
        ),
      ],
    );
  }
}
