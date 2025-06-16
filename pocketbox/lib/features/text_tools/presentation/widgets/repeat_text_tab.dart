import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_utils_provider.dart';

class RepeatTextTab extends ConsumerWidget {
  const RepeatTextTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(repeatTextProvider);
    final notifier = ref.read(repeatTextProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter text to repeat...',
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
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Number of times to repeat',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final count = int.tryParse(value) ?? 1;
                      notifier.setRepeatCount(count);
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Add separator'),
                    subtitle: const Text('Add a separator between repeated text'),
                    value: state.addSeparator,
                    onChanged: (value) {
                      notifier.setSeparator(value, state.separator);
                    },
                  ),
                  if (state.addSeparator) ...[
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Separator (e.g., space, comma)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        notifier.setSeparator(state.addSeparator, value);
                      },
                    ),
                  ],
                ],
              ),
            ),
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