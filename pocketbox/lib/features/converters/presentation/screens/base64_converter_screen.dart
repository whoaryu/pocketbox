import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/converters/domain/providers/base64_provider.dart';

class Base64ConverterScreen extends ConsumerWidget {
  const Base64ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(base64Provider);
    final notifier = ref.read(base64Provider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Base64 Converter'),
        actions: [
          IconButton(
            icon: Icon(state.isEncoding ? Icons.lock : Icons.lock_open),
            onPressed: notifier.toggleMode,
            tooltip: state.isEncoding ? 'Switch to Decode' : 'Switch to Encode',
          ),
          IconButton(
            icon: Icon(state.isImage ? Icons.image : Icons.text_fields),
            onPressed: notifier.toggleType,
            tooltip: state.isImage ? 'Switch to Text' : 'Switch to Image',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.isEncoding ? 'Text to Encode' : 'Base64 to Decode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: state.isEncoding
                    ? 'Enter text to encode...'
                    : 'Enter base64 to decode...',
                border: const OutlineInputBorder(),
              ),
              onChanged: notifier.setInput,
            ),
            const SizedBox(height: 24),
            Text(
              state.isEncoding ? 'Base64 Output' : 'Decoded Text',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                state.output.isEmpty ? 'Output will appear here...' : state.output,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 