import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pocketbox/features/generators/domain/providers/qr_code_provider.dart';

class QRCodeGeneratorScreen extends ConsumerWidget {
  const QRCodeGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qrCodeProvider);
    final notifier = ref.read(qrCodeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter text to generate QR code...',
                border: OutlineInputBorder(),
              ),
              onChanged: notifier.setInput,
            ),
            const SizedBox(height: 24),
            if (state.error != null)
              Text(
                state.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              )
            else if (state.input.isNotEmpty)
              Center(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: QrImageView(
                      data: state.input,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              )
            else
              const Center(
                child: Text(
                  'Enter text above to generate QR code',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 