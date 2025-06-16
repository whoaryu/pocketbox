import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_utils_provider.dart';

class RemoveSpacesTab extends ConsumerWidget {
  const RemoveSpacesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(removeSpacesProvider);
    final notifier = ref.read(removeSpacesProvider.notifier);

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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Remove extra spaces'),
                    subtitle: const Text('Replace multiple spaces with a single space'),
                    value: state.removeExtraSpaces,
                    onChanged: (value) {
                      notifier.setSpaceOptions(value, state.removeLeadingTrailing);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Remove leading/trailing spaces'),
                    subtitle: const Text('Remove spaces from the beginning and end'),
                    value: state.removeLeadingTrailing,
                    onChanged: (value) {
                      notifier.setSpaceOptions(state.removeExtraSpaces, value);
                    },
                  ),
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