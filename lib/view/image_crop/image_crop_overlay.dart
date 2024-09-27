import 'package:flutter/material.dart';

class ImageCropOverlay extends CustomPainter {
  const ImageCropOverlay({
    required this.rect,
  });

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          // topLeft: Radius.circular(borderRadius),
          // topRight: Radius.circular(borderRadius),
          // bottomLeft: Radius.circular(borderRadius),
          // bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final borderRect = RRect.fromRectAndCorners(
      rect,
      // topLeft: Radius.circular(borderRadius),
      // topRight: Radius.circular(borderRadius),
      // bottomLeft: Radius.circular(borderRadius),
      // bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ImageCropOverlay oldDelegate) {
    return false;
  }
}