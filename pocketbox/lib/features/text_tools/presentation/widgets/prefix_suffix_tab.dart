import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_utils_provider.dart';

class PrefixSuffixTab extends ConsumerWidget {
  const PrefixSuffixTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prefixSuffixProvider);
    final notifier = ref.read(prefixSuffixProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter text to modify...',
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
                    hintText: 'Prefix',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    notifier.setPrefixSuffix(text, state.suffix, state.applyToWords);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Suffix',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    notifier.setPrefixSuffix(state.prefix, text, state.applyToWords);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Apply to each word'),
            value: state.applyToWords,
            onChanged: (value) {
              notifier.setPrefixSuffix(state.prefix, state.suffix, value);
            },
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