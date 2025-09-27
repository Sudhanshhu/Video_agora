import 'package:flutter/material.dart';

class BottomWidget extends StatelessWidget {
  final List<BottomButton> buttons;
  final Color backgroundColor;
  final BoxDecoration? decoration;

  const BottomWidget({
    super.key,
    required this.buttons,
    this.backgroundColor = Colors.white,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons.map((button) {
          return Expanded(
            flex: button.flex,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: button.child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BottomButton {
  final Widget child;
  final int flex;

  BottomButton({
    required this.child,
    this.flex = 1,
  });
}
