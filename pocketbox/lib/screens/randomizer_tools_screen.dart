import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../features/randomizer_tools/coin_toss/screen.dart';
import '../features/randomizer_tools/dice_roller/screen.dart';
import '../features/randomizer_tools/wheel_spinner/screen.dart';

class RandomizerToolsScreen extends StatelessWidget {
  const RandomizerToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {
        'title': 'Coin Toss',
        'description': 'Flip a virtual coin with beautiful animations',
        'icon': Icons.monetization_on,
        'route': const CoinTossScreen(),
      },
      {
        'title': 'Dice Roller',
        'description': 'Roll one or more dice with realistic animations',
        'icon': Icons.casino,
        'route': const DiceRollerScreen(),
      },
      {
        'title': 'Wheel Spinner',
        'description': 'Spin a wheel to randomly select from your options',
        'icon': Icons.rotate_right,
        'route': const WheelSpinnerScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Randomizer Tools'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return Animate(
            effects: [
              FadeEffect(),
              SlideEffect(begin: const Offset(0.2, 0)),
            ],
            child: Card(
              child: ListTile(
                leading: Icon(
                  tool['icon'] as IconData,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  tool['title'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(tool['description'] as String),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => tool['route'] as Widget,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
} 