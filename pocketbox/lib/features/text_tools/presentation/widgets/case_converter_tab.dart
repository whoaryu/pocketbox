import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_utils_provider.dart';

class CaseConverterTab extends ConsumerWidget {
  const CaseConverterTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(caseConverterProvider);
    final notifier = ref.read(caseConverterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter text to convert...',
              border: OutlineInputBorder(),
            ),
            onChanged: notifier.setInput,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCaseButton(context, 'UPPERCASE', TextCase.uppercase, state.textCase, notifier),
              _buildCaseButton(context, 'lowercase', TextCase.lowercase, state.textCase, notifier),
              _buildCaseButton(context, 'Title Case', TextCase.titleCase, state.textCase, notifier),
              _buildCaseButton(context, 'Sentence case', TextCase.sentenceCase, state.textCase, notifier),
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

  Widget _buildCaseButton(
    BuildContext context,
    String label,
    TextCase textCase,
    TextCase selectedCase,
    CaseConverterNotifier notifier,
  ) {
    return FilterChip(
      label: Text(label),
      selected: selectedCase == textCase,
      onSelected: (selected) {
        if (selected) {
          notifier.setTextCase(textCase);
        }
      },
    );
  }
} 