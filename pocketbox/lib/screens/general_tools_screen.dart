import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../features/general_tools/ruler/screen.dart';
import '../features/general_tools/morse_code/screen.dart';
import '../features/general_tools/compass/screen.dart';

class GeneralToolsScreen extends StatelessWidget {
  const GeneralToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {
        'title': 'Ruler',
        'description': 'Digital ruler with zoom and measurement features',
        'icon': Icons.straighten,
        'route': const RulerScreen(),
      },
      {
        'title': 'Morse Code',
        'description': 'Convert text to Morse code and vice versa',
        'icon': Icons.code,
        'route': const MorseCodeScreen(),
      },
      {
        'title': 'Compass',
        'description': 'Digital compass with cardinal directions',
        'icon': Icons.explore,
        'route': const CompassScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('General Tools'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
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
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  tool['description'] as String,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => tool['route'] as Widget,
                  ),
                );
              },
            ),
          ).animate().fadeIn().slideX();
        },
      ),
    );
  }
} 