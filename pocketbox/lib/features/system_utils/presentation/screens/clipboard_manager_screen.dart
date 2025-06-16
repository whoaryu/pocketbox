import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/system_utils/domain/providers/clipboard_manager_provider.dart';

class ClipboardManagerScreen extends ConsumerWidget {
  const ClipboardManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clipboardManagerProvider);
    final notifier = ref.read(clipboardManagerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clipboard Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.checkClipboard(),
            tooltip: 'Check Clipboard',
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (state.currentClip != null)
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Clipboard',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(state.currentClip!),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.clips.length,
                    itemBuilder: (context, index) {
                      final clip = state.clips[index];
                      return Dismissible(
                        key: Key(clip.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) => notifier.deleteClip(clip.id),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              clip.isFavorite
                                  ? Icons.star
                                  : Icons.star_border,
                              color: clip.isFavorite
                                  ? Colors.amber
                                  : null,
                            ),
                            onPressed: () =>
                                notifier.toggleFavorite(clip.id),
                          ),
                          title: Text(clip.content),
                          subtitle: Text(
                            '${clip.timestamp.hour}:${clip.timestamp.minute} - ${clip.timestamp.day}/${clip.timestamp.month}/${clip.timestamp.year}',
                          ),
                          onTap: () => notifier.copyToClipboard(clip.content),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
} 