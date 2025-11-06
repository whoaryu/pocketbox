import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RulerScreen extends StatefulWidget {
  const RulerScreen({super.key});

  @override
  State<RulerScreen> createState() => _RulerScreenState();
}

class _RulerScreenState extends State<RulerScreen> {
  double _scale = 1.0;
  double _baseScale = 1.0;
  double _startX = 0.0;
  double _startY = 0.0;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  bool _showGrid = true;
  String _unit = 'cm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruler'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () {
              setState(() {
                _showGrid = !_showGrid;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (String value) {
              setState(() {
                _unit = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'cm',
                child: Text('Centimeters'),
              ),
              const PopupMenuItem<String>(
                value: 'in',
                child: Text('Inches'),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _baseScale = _scale;
          _startX = details.focalPoint.dx;
          _startY = details.focalPoint.dy;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale = (_baseScale * details.scale).clamp(0.5, 5.0);
            _offsetX += details.focalPoint.dx - _startX;
            _offsetY += details.focalPoint.dy - _startY;
            _startX = details.focalPoint.dx;
            _startY = details.focalPoint.dy;
          });
        },
        child: Stack(
          children: [
            // Grid
            if (_showGrid)
              CustomPaint(
                painter: GridPainter(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
                size: Size.infinite,
              ),

            // Ruler
            Transform.translate(
              offset: Offset(_offsetX, _offsetY),
              child: Transform.scale(
                scale: _scale,
                child: CustomPaint(
                  painter: RulerPainter(
                    unit: _unit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),

            // Instructions
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('• Pinch to zoom in/out'),
                      const Text('• Drag to move the ruler'),
                      const Text('• Toggle grid with the grid icon'),
                      const Text('• Change units in settings'),
                    ],
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

class GridPainter extends CustomPainter {
  final Color color;

  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RulerPainter extends CustomPainter {
  final String unit;
  final Color color;

  RulerPainter({required this.unit, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw main ruler line
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, 0),
      paint,
    );

    // Draw measurements
    final unitSize = unit == 'cm' ? 37.8 : 96.0; // pixels per unit
    final maxUnits = (size.width / unitSize).ceil();

    for (int i = 0; i <= maxUnits; i++) {
      final x = i * unitSize;
      
      // Draw major tick
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, 20),
        paint,
      );

      // Draw minor ticks
      for (int j = 1; j < 10; j++) {
        final minorX = x + (j * unitSize / 10);
        canvas.drawLine(
          Offset(minorX, 0),
          Offset(minorX, 10),
          paint..strokeWidth = 1,
        );
      }

      // Draw number
      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, 25),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 