import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MorseCodeScreen extends StatefulWidget {
  const MorseCodeScreen({super.key});

  @override
  State<MorseCodeScreen> createState() => _MorseCodeScreenState();
}

class _MorseCodeScreenState extends State<MorseCodeScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _morseController = TextEditingController();
  bool _isTextToMorse = true;

  final Map<String, String> _morseCode = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.',
    'G': '--.', 'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..',
    'M': '--', 'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.',
    'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..', '1': '.----', '2': '..---', '3': '...--',
    '4': '....-', '5': '.....', '6': '-....', '7': '--...', '8': '---..',
    '9': '----.', '0': '-----', ' ': ' ', '.': '.-.-.-', ',': '--..--',
    '?': '..--..', '!': '-.-.--', '@': '.--.-.',
  };

  final Map<String, String> _reverseMorseCode = {};

  @override
  void initState() {
    super.initState();
    _morseCode.forEach((key, value) {
      _reverseMorseCode[value] = key;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _morseController.dispose();
    super.dispose();
  }

  void _convertTextToMorse() {
    final text = _textController.text.toUpperCase();
    final morse = text.split('').map((char) {
      return _morseCode[char] ?? char;
    }).join(' ');
    _morseController.text = morse;
  }

  void _convertMorseToText() {
    final morse = _morseController.text;
    final words = morse.split('   '); // Three spaces between words
    final text = words.map((word) {
      return word.split(' ').map((char) {
        return _reverseMorseCode[char] ?? char;
      }).join('');
    }).join(' ');
    _textController.text = text;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morse Code'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isTextToMorse ? Icons.arrow_forward : Icons.arrow_back),
            onPressed: () {
              setState(() {
                _isTextToMorse = !_isTextToMorse;
                _textController.clear();
                _morseController.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text input
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: _isTextToMorse ? 'Enter text' : 'Morse code result',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(_textController.text),
                ),
              ),
              maxLines: 3,
              onChanged: (_) {
                if (_isTextToMorse) {
                  _convertTextToMorse();
                }
              },
            ),
            const SizedBox(height: 16),

            // Convert button
            ElevatedButton(
              onPressed: _isTextToMorse ? _convertTextToMorse : _convertMorseToText,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_isTextToMorse ? 'Convert to Morse' : 'Convert to Text'),
            ),
            const SizedBox(height: 16),

            // Morse code input
            TextField(
              controller: _morseController,
              decoration: InputDecoration(
                labelText: _isTextToMorse ? 'Morse code result' : 'Enter morse code',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(_morseController.text),
                ),
              ),
              maxLines: 3,
              onChanged: (_) {
                if (!_isTextToMorse) {
                  _convertMorseToText();
                }
              },
            ),
            const SizedBox(height: 16),

            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                    const Text('• Enter text to convert to Morse code'),
                    const Text('• Enter Morse code to convert to text'),
                    const Text('• Use dots (.) and dashes (-) for Morse code'),
                    const Text('• Separate letters with spaces'),
                    const Text('• Separate words with three spaces'),
                    const Text('• Tap the arrow to switch conversion direction'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 