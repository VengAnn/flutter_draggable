import 'package:flutter/material.dart';
import 'dart:math';

class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  Offset _position = const Offset(50, 50); // Initial position of the shape
  double _rotationAngle = 0.0; // Initial rotation angle (in radians)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movable & Rotatable Shape'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Section 1: Instructions
            Container(
              color: Colors.blue[100],
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Drag the shape to move it within the green zone.\nTap the shape to rotate it.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            // Section 2: Drop Zone
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Positioned(
                          top: _position.dy,
                          left: _position.dx,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                double newX = _position.dx + details.delta.dx;
                                double newY = _position.dy + details.delta.dy;

                                // Constrain movement within the container
                                newX =
                                    newX.clamp(0.0, constraints.maxWidth - 50);
                                newY =
                                    newY.clamp(0.0, constraints.maxHeight - 50);

                                _position = Offset(newX, newY);
                              });
                            },
                            onTap: () {
                              setState(() {
                                // Rotate the triangle 45 degrees (in radians)
                                _rotationAngle +=
                                    pi / 4; // 45 degrees = pi / 4 radians
                              });
                            },
                            child: Transform.rotate(
                              angle: _rotationAngle,
                              child: _buildTriangle(50), // Size of the triangle
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a custom triangle shape
  Widget _buildTriangle(double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: TrianglePainter(),
    );
  }
}

/// CustomPainter to draw a triangle
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.fill;

    // Draw an equilateral triangle
    Path path = Path();
    path.moveTo(size.width / 2, 0); // Top point
    path.lineTo(0, size.height); // Bottom-left point
    path.lineTo(size.width, size.height); // Bottom-right point
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}
