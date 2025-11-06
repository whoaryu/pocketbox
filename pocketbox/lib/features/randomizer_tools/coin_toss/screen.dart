import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CoinTossScreen extends StatefulWidget {
  const CoinTossScreen({super.key});

  @override
  State<CoinTossScreen> createState() => _CoinTossScreenState();
}

class _CoinTossScreenState extends State<CoinTossScreen> with SingleTickerProviderStateMixin {
  bool _isFlipping = false;
  bool _isHeads = true;
  final Random _random = Random();
  final List<bool> _history = [];
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_flipController);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCoin() {
    if (_isFlipping) return;

    setState(() {
      _isFlipping = true;
    });

    // Simulate multiple flips
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _flipController.forward(from: 0).then((_) {
            setState(() {
              _isHeads = !_isHeads;
            });
          });
        }
      });
    }

    // Final result
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _flipController.forward(from: 0).then((_) {
          setState(() {
            _isHeads = _random.nextBool();
            _history.insert(0, _isHeads);
            if (_history.length > 10) {
              _history.removeLast();
            }
            _isFlipping = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Toss'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Coin
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_flipAnimation.value * pi),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isHeads ? Colors.amber : Colors.blueGrey,
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
                              _isHeads ? 'H' : 'T',
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Result text
                  Text(
                    _isFlipping ? 'Flipping...' : (_isHeads ? 'Heads!' : 'Tails!'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(
                    target: _isFlipping ? 1 : 0,
                  ).fadeIn(
                    duration: const Duration(milliseconds: 200),
                  ),

                  const SizedBox(height: 40),

                  // Flip button
                  ElevatedButton(
                    onPressed: _isFlipping ? null : _flipCoin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                    ),
                    child: const Text(
                      'Flip Coin',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
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
                        final isHeads = _history[index];
                        return ListTile(
                          leading: Icon(
                            isHeads ? Icons.monetization_on : Icons.monetization_on_outlined,
                            color: isHeads ? Colors.amber : Colors.blueGrey,
                          ),
                          title: Text(isHeads ? 'Heads' : 'Tails'),
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
} 