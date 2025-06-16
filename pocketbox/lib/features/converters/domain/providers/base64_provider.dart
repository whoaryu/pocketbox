import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class Base64State {
  final String input;
  final String output;
  final bool isEncoding;
  final bool isImage;

  const Base64State({
    this.input = '',
    this.output = '',
    this.isEncoding = true,
    this.isImage = false,
  });

  Base64State copyWith({
    String? input,
    String? output,
    bool? isEncoding,
    bool? isImage,
  }) {
    return Base64State(
      input: input ?? this.input,
      output: output ?? this.output,
      isEncoding: isEncoding ?? this.isEncoding,
      isImage: isImage ?? this.isImage,
    );
  }
}

class Base64Notifier extends StateNotifier<Base64State> {
  Base64Notifier() : super(const Base64State());

  void setInput(String input) {
    state = state.copyWith(input: input);
    _processInput();
  }

  void toggleMode() {
    state = state.copyWith(
      isEncoding: !state.isEncoding,
      input: state.output,
      output: state.input,
    );
  }

  void toggleType() {
    state = state.copyWith(
      isImage: !state.isImage,
      input: '',
      output: '',
    );
  }

  void _processInput() {
    if (state.input.isEmpty) {
      state = state.copyWith(output: '');
      return;
    }

    try {
      if (state.isEncoding) {
        if (state.isImage) {
          // For images, we expect the input to be a base64 string
          state = state.copyWith(output: state.input);
        } else {
          state = state.copyWith(
            output: base64Encode(utf8.encode(state.input)),
          );
        }
      } else {
        if (state.isImage) {
          // For images, we expect the input to be a base64 string
          state = state.copyWith(output: state.input);
        } else {
          state = state.copyWith(
            output: utf8.decode(base64Decode(state.input)),
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        output: 'Error: Invalid ${state.isEncoding ? 'text' : 'base64'} input',
      );
    }
  }
}

final base64Provider = StateNotifierProvider<Base64Notifier, Base64State>((ref) {
  return Base64Notifier();
}); 