import 'package:flutter/material.dart';

enum ScannerMode { receipt, barcode }

class ScannerOverlay extends StatelessWidget {
  final ScannerMode mode;

  const ScannerOverlay({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: ScannerOverlayPainter(mode: mode),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final ScannerMode mode;

  ScannerOverlayPainter({required this.mode});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.8);

    final clearPaint = Paint()..blendMode = BlendMode.clear;

    final overlayLayer = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.saveLayer(overlayLayer, Paint());

    canvas.drawRect(overlayLayer, backgroundPaint);

    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: mode == ScannerMode.receipt ? 420 : 160,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(20)),
      clearPaint,
    );

    canvas.restore();

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(20)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.mode != mode;
  }
}
