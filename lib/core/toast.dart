import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'utils/colors/colors.dart';

/// Alert type enum to define different scenarios
enum AlertType {
  success,
  failure,
  warning,
  info,
  custom,
}

void fToast(
  String msg, {
  AlertType type = AlertType.info,
  double fontSize = 16,
  int time = 1,
  ToastGravity? gravity,
}) {
  Color backgroundColor;
  Color textColor = Colors.white;

  switch (type) {
    case AlertType.success:
      backgroundColor = AppColors.success;
      break;
    case AlertType.failure:
      backgroundColor = AppColors.error;
      break;
    case AlertType.info:
      backgroundColor = AppColors.info;
      break;
    case AlertType.warning:
      backgroundColor = AppColors.warning;
      break;
    default:
      backgroundColor = AppColors.neutral;
  }

  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    timeInSecForIosWeb: time,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}

/// Enhanced alert box that supports different scenarios
kAlertBox<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  AlertType type = AlertType.custom,
  bool isDismissible = true,
  bool isScrollable = false,
  bool isBarrierDismissible = true,
  List<Widget> actionBtns = const [],
  Color? backgroundColor,
  Color? titleColor,
  IconData? icon,
}) {
  // Define colors and icons based on alert type
  final Map<AlertType, _AlertStyle> alertStyles = {
    AlertType.success: _AlertStyle(
      backgroundColor: Colors.green[50],
      iconData: Icons.check_circle,
      iconColor: AppColors.success,
      titleColor: Colors.green[800],
    ),
    AlertType.failure: _AlertStyle(
      backgroundColor: Colors.red[50],
      iconData: Icons.error_outline,
      iconColor: AppColors.error,
      titleColor: Colors.red[800],
    ),
    AlertType.warning: _AlertStyle(
      backgroundColor: Colors.orange[50],
      iconData: Icons.warning_amber_outlined,
      iconColor: Colors.orange,
      titleColor: Colors.orange[800],
    ),
    AlertType.info: _AlertStyle(
      backgroundColor: Colors.blue[50],
      iconData: Icons.info_outline,
      iconColor: AppColors.info,
      titleColor: Colors.blue[800],
    ),
    AlertType.custom: _AlertStyle(
      backgroundColor: backgroundColor,
      iconData: icon,
      iconColor: null,
      titleColor: titleColor,
    ),
  };

  final currentStyle = alertStyles[type]!;

  return showDialog(
    context: context,
    barrierDismissible: isBarrierDismissible,
    builder: (context) => AlertDialog(
      // contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      backgroundColor: currentStyle.backgroundColor,
      title: Row(
        children: [
          if (currentStyle.iconData != null) ...[
            Icon(
              currentStyle.iconData,
              color: currentStyle.iconColor,
              size: 24,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: currentStyle.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: content,
      scrollable: isScrollable,
      actions: actionBtns,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

/// Helper class to store alert styling properties
class _AlertStyle {
  final Color? backgroundColor;
  final IconData? iconData;
  final Color? iconColor;
  final Color? titleColor;

  _AlertStyle({
    this.backgroundColor,
    this.iconData,
    this.iconColor,
    this.titleColor,
  });
}
