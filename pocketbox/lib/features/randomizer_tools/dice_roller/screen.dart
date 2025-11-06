import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({super.key});

  @override
  State<DiceRollerScreen> createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  final Random _random = Random();
  bool _isRolling = false;
  int _numberOfDice = 1;
  List<int> _diceValues = [1];
  final List<List<int>> _history = [];

  void _rollDice() {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    // Simulate multiple rolls with animation
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          setState(() {
            _diceValues = List.generate(
              _numberOfDice,
              (_) => _random.nextInt(6) + 1,
            );
          });
        }
      });
    }

    // Final result
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _diceValues = List.generate(
            _numberOfDice,
            (_) => _random.nextInt(6) + 1,
          );
          _history.insert(0, List.from(_diceValues));
          if (_history.length > 10) {
            _history.removeLast();
          }
          _isRolling = false;
        });
      }
    });
  }

  void _changeNumberOfDice(int value) {
    setState(() {
      _numberOfDice = value;
      _diceValues = List.generate(value, (_) => 1);
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Roller'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dice count selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Number of Dice:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 16),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('1')),
                    ButtonSegment(value: 2, label: Text('2')),
                    ButtonSegment(value: 3, label: Text('3')),
                  ],
                  selected: {_numberOfDice},
                  onSelectionChanged: (Set<int> newSelection) {
                    _changeNumberOfDice(newSelection.first);
                  },
                ),
              ],
            ),
          ),

          // Dice display
          Expanded(
            flex: 2,
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(
                  _numberOfDice,
                  (index) => _buildDice(_diceValues[index]),
                ),
              ),
            ),
          ),

          // Roll button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isRolling ? null : _rollDice,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                _isRolling ? 'Rolling...' : 'Roll Dice',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),

          // History
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final roll = _history[index];
                        return ListTile(
                          leading: const Icon(Icons.casino),
                          title: Text(
                            roll.join(' + ') + ' = ${roll.reduce((a, b) => a + b)}',
                          ),
                          trailing: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDice(int value) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate(
      target: _isRolling ? 1 : 0,
    ).rotate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    ).scale(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }
} 