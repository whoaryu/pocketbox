import 'package:flutter_riverpod/flutter_riverpod.dart';

class QRCodeState {
  final String input;
  final String? error;

  const QRCodeState({
    this.input = '',
    this.error,
  });

  QRCodeState copyWith({
    String? input,
    String? error,
  }) {
    return QRCodeState(
      input: input ?? this.input,
      error: error,
    );
  }
}

class QRCodeNotifier extends StateNotifier<QRCodeState> {
  QRCodeNotifier() : super(const QRCodeState());

  void setInput(String input) {
    state = state.copyWith(input: input, error: null);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }
}

final qrCodeProvider = StateNotifierProvider<QRCodeNotifier, QRCodeState>((ref) {
  return QRCodeNotifier();
}); 