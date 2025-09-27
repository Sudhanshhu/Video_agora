import 'package:flutter/material.dart';

class AppColors {
  static Color colorFromHex(String? hexColor) {
    hexColor = hexColor ?? "#999999";
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static List<Color> listOfColorFromHex(List<String>? colorsList) {
    if (colorsList == null || colorsList.isEmpty) {
      return [Colors.transparent];
    }
    List<Color> listOfColor = colorsList.map((e) {
      final hexCode = e.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }).toList();
    return listOfColor;
  }

  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = Color(0xFF2196F3); // Blue
  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color neutral = Color(0xFF9E9E9E); // Grey
}
