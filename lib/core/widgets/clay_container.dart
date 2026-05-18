import 'package:flutter/material.dart';
import '../../theme.dart'; // Imports the master theme

class ClayContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const ClayContainer({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = 32,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Automatically fallback to proper premium slate Color in dark mode
    final defaultColor = color ?? (isDark ? const Color(0xFF1E293B) : Colors.white);

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: AppTheme.getClayDecoration(
        color: defaultColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
