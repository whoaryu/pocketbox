import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_utils_provider.dart';

class WordCounterTab extends ConsumerWidget {
  const WordCounterTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wordCounterProvider);
    final notifier = ref.read(wordCounterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter text to analyze...',
              border: OutlineInputBorder(),
            ),
            onChanged: notifier.setInput,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStatRow('Words', state.wordCount.toString()),
                  const Divider(),
                  _buildStatRow('Characters', state.charCount.toString()),
                  const Divider(),
                  _buildStatRow('Sentences', state.sentenceCount.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 