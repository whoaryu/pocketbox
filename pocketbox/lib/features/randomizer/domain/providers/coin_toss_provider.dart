import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class CoinTossState {
  final bool isTossing;
  final bool? result;
  final int tossCount;

  const CoinTossState({
    this.isTossing = false,
    this.result,
    this.tossCount = 0,
  });

  CoinTossState copyWith({
    bool? isTossing,
    bool? result,
    int? tossCount,
  }) {
    return CoinTossState(
      isTossing: isTossing ?? this.isTossing,
      result: result ?? this.result,
      tossCount: tossCount ?? this.tossCount,
    );
  }
}

class CoinTossNotifier extends StateNotifier<CoinTossState> {
  CoinTossNotifier() : super(const CoinTossState());

  Future<void> toss() async {
    state = state.copyWith(isTossing: true, result: null);
    
    // Simulate tossing animation
    await Future.delayed(const Duration(milliseconds: 500));
    
    final random = Random();
    final result = random.nextBool();
    
    state = state.copyWith(
      isTossing: false,
      result: result,
      tossCount: state.tossCount + 1,
    );
  }
}

final coinTossProvider = StateNotifierProvider<CoinTossNotifier, CoinTossState>((ref) {
  return CoinTossNotifier();
}); 