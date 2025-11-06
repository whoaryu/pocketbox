import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double? _direction;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _initCompass();
  }

  void _initCompass() {
    FlutterCompass.events?.listen((event) {
      setState(() {
        _direction = event.heading;
      });
    }, onError: (error) {
      setState(() {
        _hasPermissions = false;
      });
    });
  }

  String _getDirection(double? heading) {
    if (heading == null) return 'N/A';
    
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((heading + 22.5) % 360 / 45).floor();
    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_hasPermissions)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Please enable location services to use the compass',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Compass
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Compass background
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  // Cardinal directions
                  ...['N', 'E', 'S', 'W'].map((direction) {
                    final angle = {
                      'N': 0.0,
                      'E': 90.0,
                      'S': 180.0,
                      'W': 270.0,
                    }[direction]!;
                    
                    return Transform.rotate(
                      angle: math.pi * 2 * (angle / 360),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Text(
                          direction,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                  // Compass needle
                  Transform.rotate(
                    angle: _direction != null
                        ? math.pi * 2 * (_direction! / 360)
                        : 0,
                    child: const Icon(
                      Icons.navigation,
                      size: 200,
                      color: Colors.red,
                    ),
                  ),
                  // Center point
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Direction text
            Text(
              _getDirection(_direction),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Degrees
            Text(
              _direction != null
                  ? '${_direction!.toStringAsFixed(1)}°'
                  : 'N/A',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 