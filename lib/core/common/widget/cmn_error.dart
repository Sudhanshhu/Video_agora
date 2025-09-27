// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CommonErrorPg extends StatelessWidget {
  final String msg;
  const CommonErrorPg({
    super.key,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(msg),
    );
  }
}
