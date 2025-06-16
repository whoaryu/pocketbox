import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/randomizer/domain/providers/coin_toss_provider.dart';

class CoinTossScreen extends ConsumerWidget {
  const CoinTossScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coinTossProvider);
    final notifier = ref.read(coinTossProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Toss'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isTossing
                  ? const Icon(
                      Icons.monetization_on,
                      size: 120,
                      key: ValueKey('tossing'),
                    )
                  : Icon(
                      Icons.monetization_on,
                      size: 120,
                      color: state.result == null
                          ? Colors.grey
                          : state.result!
                              ? Colors.amber
                              : Colors.grey.shade800,
                      key: ValueKey('result'),
                    ),
            ),
            const SizedBox(height: 32),
            if (state.result != null)
              Text(
                state.result! ? 'Heads!' : 'Tails!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            const SizedBox(height: 16),
            Text(
              'Tosses: ${state.tossCount}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: state.isTossing ? null : () => notifier.toss(),
              icon: const Icon(Icons.refresh),
              label: const Text('Toss Coin'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 