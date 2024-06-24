import 'package:flutter/material.dart';



enum SliderShape{
  upwardTriangle,
  downwardTriangle,
  line
}






// Made by [Houngseob Noh]
// Date: 2024/06/18
class VerticalSlider extends StatefulWidget {

  final double min;
  final double max;
  final double? initialValue;
  final ValueChanged<double> onChanged;
  final double speedFactor;
  final Color? thumbColor;
  final Color? sliderColor;
  final SliderShape? sliderShape;
  final double width;
  final double height;
  final VoidCallback? onMinReached;
  final VoidCallback? onMaxReached;

  const VerticalSlider({
    Key? key,
    required this.min,
    required this.max,
    this.initialValue,
    required this.onChanged,
    this.speedFactor = 1.0,
    this.thumbColor = Colors.white,
    this.sliderColor = Colors.grey,
    this.sliderShape = SliderShape.line,
    required this.width,
    required this.height,
    this.onMinReached,
    this.onMaxReached,
  });

  @override
  State<VerticalSlider> createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {

  late double _currentValue;
  bool _minReached = false;
  bool _maxReached = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? (widget.min + widget.max) / 2;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          double newValue = _currentValue - details.delta.dy * widget.speedFactor;
          if (newValue <= widget.min) {
            newValue = widget.min;
            if (!_minReached) {
              _minReached = true;
              widget.onMinReached?.call();
            }
          } else if (newValue >= widget.max) {
            newValue = widget.max;
            if (!_maxReached) {
              _maxReached = true;
              widget.onMaxReached?.call();
            }
          } else {
            _minReached = false;
            _maxReached = false;
          }
          _currentValue = newValue;
          widget.onChanged(_currentValue);
        });
      },
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _SliderPainter(
          min: widget.min,
          max: widget.max,
          value: _currentValue,
          thumbColor: widget.thumbColor!,
          sliderColor: widget.sliderColor!,
          sliderShape: widget.sliderShape!,
        ),
      ),
    );
  }


}























class _SliderPainter extends CustomPainter {
  final double min;
  final double max;
  final double value;
  final Color thumbColor;
  final Color sliderColor;
  final SliderShape sliderShape;

  _SliderPainter({
    required this.min,
    required this.max,
    required this.value,
    required this.thumbColor,
    required this.sliderColor,
    required this.sliderShape,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // slider bar
    final paint = Paint()
      ..color = sliderColor;

    // thumb
    final thumbPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;




    // shape
    switch(sliderShape){
      case SliderShape.upwardTriangle:{
        Path trianglePath = Path();
        trianglePath.moveTo(size.width / 2, 0); // Top center
        trianglePath.lineTo(0, size.height); // Bottom left
        trianglePath.lineTo(size.width, size.height); // Bottom right
        trianglePath.close();
        canvas.drawPath(trianglePath, paint);
      }
      case SliderShape.downwardTriangle:{
        Path trianglePath = Path();
        trianglePath.moveTo(0, 0); // top left
        trianglePath.lineTo(size.width, 0); // top right
        trianglePath.lineTo(size.width / 2, size.height); // bottom center
        trianglePath.close();
        canvas.drawPath(trianglePath, paint);
      }
      case SliderShape.line:
      default: {
        paint
          ..strokeWidth = size.width / 2
          ..strokeCap = StrokeCap.round;
      }
    }



    // Draw the slider track
    final trackStart = Offset(size.width / 2, 0);
    final trackEnd = Offset(size.width / 2, size.height);
    canvas.drawLine(trackStart, trackEnd, paint);

    // Calculate thumb position
    double thumbPosition = size.height * (1 - (value - min) / (max - min));

    // Draw the thumb
    final thumbRadius = size.width / 2;
    final thumbCenter = Offset(size.width / 2, thumbPosition);
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
