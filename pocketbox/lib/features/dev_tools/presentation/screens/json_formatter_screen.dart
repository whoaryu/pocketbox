import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/dev_tools/domain/providers/json_formatter_provider.dart';

class JSONFormatterScreen extends ConsumerWidget {
  const JSONFormatterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jsonFormatterProvider);
    final notifier = ref.read(jsonFormatterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Formatter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Input JSON',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Paste your JSON here...',
                  border: OutlineInputBorder(),
                ),
                onChanged: notifier.setInput,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Formatted JSON',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    state.error ?? state.output,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: state.error != null
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 