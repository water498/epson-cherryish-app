import 'dart:ui';

import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;

  DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashLength = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    // 사각형 경로 그리기
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 점선 스타일로 변환
    _drawDashedPath(canvas, paint, path);
  }

  void _drawDashedPath(Canvas canvas, Paint paint, Path path) {
    const double dashSpace = 3.0; // 점선 사이의 간격
    final PathMetrics pathMetrics = path.computeMetrics();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;

      while (distance < pathMetric.length) {
        final Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawLine(tangent.position, tangent.position + tangent.vector * dashLength, paint);
        }
        distance += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}