import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CameraFrame extends StatelessWidget {
  final double width;
  final double height;
  final Color cornerColor;
  final double cornerLength;
  final double cornerWidth;
  final double borderRadius;

  const CameraFrame({
    super.key,
    required this.width,
    required this.height,
    this.cornerColor = AppColors.white,
    this.cornerLength = 50.0,
    this.cornerWidth = 2.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: CornerFramePainter(
          cornerColor: cornerColor,
          cornerLength: cornerLength,
          cornerWidth: cornerWidth,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class CornerFramePainter extends CustomPainter {
  final Color cornerColor;
  final double cornerLength;
  final double cornerWidth;
  final double borderRadius;

  CornerFramePainter({
    required this.cornerColor,
    required this.cornerLength,
    required this.cornerWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cornerColor
      ..strokeWidth = cornerWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path topLeft = Path()
      ..moveTo(0 + borderRadius, 0)
      ..lineTo(cornerLength, 0)
      ..moveTo(0, borderRadius)
      ..lineTo(0, cornerLength);
    canvas.drawPath(topLeft, paint);

    Path topRight = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - borderRadius, 0)
      ..moveTo(size.width, borderRadius)
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(topRight, paint);

    Path bottomLeft = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - borderRadius)
      ..moveTo(borderRadius, size.height)
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(bottomLeft, paint);

    Path bottomRight = Path()
      ..moveTo(size.width, size.height - cornerLength)
      ..lineTo(size.width, size.height - borderRadius)
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width - borderRadius, size.height);
    canvas.drawPath(bottomRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
