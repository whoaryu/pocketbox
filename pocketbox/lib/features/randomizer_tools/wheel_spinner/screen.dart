import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WheelSpinnerScreen extends StatefulWidget {
  const WheelSpinnerScreen({super.key});

  @override
  State<WheelSpinnerScreen> createState() => _WheelSpinnerScreenState();
}

class _WheelSpinnerScreenState extends State<WheelSpinnerScreen> {
  final TextEditingController _textController = TextEditingController();
  final StreamController<int> _wheelController = StreamController<int>();
  final List<String> _items = [];
  bool _isSpinning = false;
  int _selectedIndex = 0;
  final Random _random = Random();

  @override
  void dispose() {
    _textController.dispose();
    _wheelController.close();
    super.dispose();
  }

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add(_textController.text);
        _textController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _spinWheel() {
    if (_items.length < 2) return;
    setState(() {
      _isSpinning = true;
    });

    // Generate a random number of full rotations (3-5) plus the final position
    final rotations = 3 + _random.nextInt(3);
    final finalPosition = _random.nextInt(_items.length);
    final totalSteps = (rotations * _items.length) + finalPosition;

    // Create a stream of positions
    final positions = List.generate(totalSteps, (index) {
      return index % _items.length;
    });

    // Emit positions with increasing delay
    for (int i = 0; i < positions.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          _wheelController.add(positions[i]);
        }
      });
    }

    // End the spin
    Future.delayed(Duration(milliseconds: positions.length * 50), () {
      if (mounted) {
        setState(() {
          _isSpinning = false;
          _selectedIndex = finalPosition;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wheel Spinner'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Input field for new items
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Enter an option',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // List of items
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_items[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeItem(index),
                            ),
                          ),
                        ).animate().fadeIn().slideX();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Wheel section
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: _items.length < 2
                ? Center(
                    child: Text(
                      'Add at least 2 options to spin the wheel!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      FortuneWheel(
                        selected: _wheelController.stream,
                        animateFirst: false,
                        items: [
                          for (var item in _items)
                            FortuneItem(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: FortuneItemStyle(
                                color: Colors.primaries[_items.indexOf(item) % Colors.primaries.length],
                                borderColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
          ),
          
          // Spin button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _items.length < 2 || _isSpinning ? null : _spinWheel,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_isSpinning ? 'Spinning...' : 'Spin the Wheel!'),
            ),
          ),
        ],
      ),
    );
  }
} 