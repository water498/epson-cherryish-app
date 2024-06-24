import 'package:flutter/material.dart';


class GradientColorPicker extends StatefulWidget {
  @override
  _GradientColorPickerState createState() => _GradientColorPickerState();
}

class _GradientColorPickerState extends State<GradientColorPicker> {
  GlobalKey _paintKey = GlobalKey();
  Color _currentColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gradient Color Picker")),
      body: GestureDetector(
        onPanUpdate: (details) async {
          // Color color = await _getColorAtPosition(details.globalPosition);
          // setState(() {
          //   _currentColor = color;
          // });
        },
        child: Stack(
          children: [
            CustomPaint(
              key: _paintKey,
              size: Size(double.infinity, double.infinity),
              painter: GradientPainter(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Text(
                  'Current Color: $_currentColor',
                  style: TextStyle(
                    color: _currentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red, Colors.blue, Colors.green],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}