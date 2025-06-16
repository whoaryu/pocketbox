import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class JSONFormatterState {
  final String input;
  final String output;
  final String? error;

  const JSONFormatterState({
    this.input = '',
    this.output = '',
    this.error,
  });

  JSONFormatterState copyWith({
    String? input,
    String? output,
    String? error,
  }) {
    return JSONFormatterState(
      input: input ?? this.input,
      output: output ?? this.output,
      error: error,
    );
  }
}

class JSONFormatterNotifier extends StateNotifier<JSONFormatterState> {
  JSONFormatterNotifier() : super(const JSONFormatterState());

  void setInput(String input) {
    state = state.copyWith(input: input, error: null);
    _formatJSON(input);
  }

  void _formatJSON(String input) {
    if (input.isEmpty) {
      state = state.copyWith(output: '', error: null);
      return;
    }

    try {
      final jsonObject = jsonDecode(input);
      final formattedJson = const JsonEncoder.withIndent('  ').convert(jsonObject);
      state = state.copyWith(output: formattedJson, error: null);
    } catch (e) {
      state = state.copyWith(
        output: '',
        error: 'Invalid JSON: ${e.toString()}',
      );
    }
  }
}

final jsonFormatterProvider =
    StateNotifierProvider<JSONFormatterNotifier, JSONFormatterState>((ref) {
  return JSONFormatterNotifier();
}); 