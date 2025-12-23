import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.desktop,
  });

  static const double mobileBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= mobileBreakpoint && desktop != null) {
          return desktop!;
        } else {
          return mobile;
        }
      },
    );
  }
}