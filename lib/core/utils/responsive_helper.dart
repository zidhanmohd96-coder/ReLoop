import 'package:flutter/material.dart';

extension ResponsiveLayout on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  Orientation get orientation => MediaQuery.of(this).orientation;
  bool get isTablet => screenWidth >= 600;
  bool get isLandscape => orientation == Orientation.landscape;

  // Scale padding/margins based on screen width (for 320px to 480px and larger)
  double scalePadding(double base) {
    if (screenWidth < 360) {
      return base * 0.65;
    } else if (screenWidth < 480) {
      return base * 0.85;
    } else if (isTablet) {
      return base * 1.3;
    }
    return base;
  }

  // Scale font sizes dynamically based on screen density
  double scaleFont(double baseSize) {
    double scaleFactor = screenWidth / 375.0; // standard base scale width
    if (isTablet) {
      scaleFactor = scaleFactor * 0.7; // clamp tablet text scaling to avoid oversized texts
    }
    double scaled = baseSize * scaleFactor;
    return scaled.clamp(baseSize * 0.75, baseSize * 1.6);
  }

  // Calculate proportional card widths
  double scaleCardWidth({required double mobileRatio, required double tabletRatio}) {
    if (isTablet) {
      return screenWidth * tabletRatio;
    }
    return screenWidth * mobileRatio;
  }
}
