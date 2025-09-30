// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:ecommerce/core/utils/media_res.dart';

class LoadingView extends StatelessWidget {
  final String? msg;
  const LoadingView({
    super.key,
    this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          Lottie.asset(
            MediaRes.loading,
            repeat: false,
          ),
          Text(msg ?? ""),
        ],
      ),
    );
  }
}
