import 'package:flutter/material.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';

/// Logo NFC personnalisé avec ondes en spirale et couleur Anycubic
class NfcLogo extends StatelessWidget {
  const NfcLogo({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _NfcLogoPainter()),
    );
  }
}

class _NfcLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.anycubicRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    // Dessiner 3 ondes NFC en spirale
    for (int i = 0; i < 3; i++) {
      final radius = (size.width / 2) * (0.3 + i * 0.25);
      final arcRect = Rect.fromCircle(center: center, radius: radius);

      // Arc de cercle (ondes NFC)
      canvas.drawArc(
        arcRect,
        -2.8, // Angle de départ (radians)
        4.7, // Angle de balayage
        false,
        paint,
      );
    }

    // Point central (chip NFC)
    final chipPaint = Paint()
      ..color = AppTheme.anycubicRed
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 8, chipPaint);

    // Contour du chip
    final chipOutlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, 8, chipOutlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
