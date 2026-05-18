import 'package:flutter/material.dart';

class KeralaOutlinePainter extends CustomPainter {
  final bool isDark;
  
  KeralaOutlinePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.45, h * 0.05);
    path.quadraticBezierTo(w * 0.35, h * 0.25, w * 0.40, h * 0.45);
    path.quadraticBezierTo(w * 0.55, h * 0.65, w * 0.45, h * 0.95);
    path.lineTo(w * 0.65, h * 0.90);
    path.quadraticBezierTo(w * 0.75, h * 0.60, w * 0.60, h * 0.35);
    path.quadraticBezierTo(w * 0.55, h * 0.15, w * 0.60, h * 0.05);
    path.close();

    canvas.drawPath(path, paint);

    final strokePaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
