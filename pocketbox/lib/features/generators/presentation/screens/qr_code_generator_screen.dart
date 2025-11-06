import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pocketbox/features/generators/domain/providers/qr_code_provider.dart';

class QRCodeGeneratorScreen extends ConsumerStatefulWidget {
  const QRCodeGeneratorScreen({super.key});

  @override
  ConsumerState<QRCodeGeneratorScreen> createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends ConsumerState<QRCodeGeneratorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MobileScannerController? _scannerController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    try {
      _scannerController = MobileScannerController();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize camera. Please check camera permissions.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qrCodeProvider);
    final notifier = ref.read(qrCodeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Tools'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Generate'),
            Tab(text: 'Scan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Generate Tab
          Padding(
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
          // Scan Tab
          _isCameraInitialized
              ? Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController!,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null) {
                            notifier.setInput(barcode.rawValue!);
                            _tabController.animateTo(0); // Switch to generate tab
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Scanned: ${barcode.rawValue}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.flash_on),
                            onPressed: () => _scannerController?.toggleTorch(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_rear),
                            onPressed: () => _scannerController?.switchCamera(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Camera not available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please check camera permissions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
} 