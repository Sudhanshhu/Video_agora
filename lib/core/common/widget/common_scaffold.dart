import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final bool showAppBar;
  final Gradient? gradient;
  final Color? appBarColor;
  final double appBarElevation;
  final PreferredSizeWidget? customAppBar;

  const CommonScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.actions,
    this.bottomNavigationBar,
    this.showAppBar = true,
    this.gradient,
    this.appBarColor,
    this.appBarElevation = 0,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: showAppBar
          ? (customAppBar ??
              AppBar(
                title: Text(title),
                elevation: appBarElevation,
                backgroundColor: appBarColor ?? Colors.transparent,
                actions: actions,
              ))
          : null,

      // Gradient Background
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient ??
              const LinearGradient(
                colors: [
                  Color(0xFF1E1E2C),
                  Color(0xFF2A2A40),
                  Color(0xFF3D3D60),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        ),
        child: SafeArea(child: body),
      ),

      // Optional Bottom Nav & FAB
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
