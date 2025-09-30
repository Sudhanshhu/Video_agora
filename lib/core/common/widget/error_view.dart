// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce/core/common/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/media_res.dart';

class ErrorViewWidget extends StatelessWidget {
  final String msg;
  final VoidCallback? onRetry;
  const ErrorViewWidget({
    super.key,
    required this.msg,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ErrorView(
      msg: msg,
      onRetry: onRetry,
    ));
  }
}

class ErrorView extends StatelessWidget {
  final String msg;
  final VoidCallback? onRetry;
  const ErrorView({
    super.key,
    required this.msg,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Lottie.asset(
            MediaRes.error,
            repeat: false,
            height: 250,
            width: 200,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Error: $msg',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 32),
        if (onRetry != null)
          KPrimaryBtn(
            onPressed: onRetry,
            text: "Retry",
          ),
      ],
    );
  }
}
