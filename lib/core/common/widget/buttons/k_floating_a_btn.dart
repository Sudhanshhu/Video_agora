import 'package:flutter/material.dart';

class KFLoatingActionBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const KFLoatingActionBtn({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: onPressed, child: child);
  }
}
