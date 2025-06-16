import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_utils_provider.dart';

class FindReplaceTab extends ConsumerWidget {
  const FindReplaceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(findReplaceProvider);
    final notifier = ref.read(findReplaceProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter text to search in...',
              border: OutlineInputBorder(),
            ),
            onChanged: notifier.setInput,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Find',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    notifier.setFindReplace(text, state.replaceText);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Replace with',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    notifier.setFindReplace(state.findText, text);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    state.output,
                    style: const TextStyle(fontSize: 16),
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