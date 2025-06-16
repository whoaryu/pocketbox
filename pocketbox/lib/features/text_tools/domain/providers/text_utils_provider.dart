import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/models/text_utils_model.dart';

enum TextCase { uppercase, lowercase, titleCase, sentenceCase, none }

// Word Counter Provider
class WordCounterState {
  final String input;
  final int wordCount;
  final int charCount;
  final int sentenceCount;

  const WordCounterState({
    this.input = '',
    this.wordCount = 0,
    this.charCount = 0,
    this.sentenceCount = 0,
  });

  WordCounterState copyWith({
    String? input,
    int? wordCount,
    int? charCount,
    int? sentenceCount,
  }) {
    return WordCounterState(
      input: input ?? this.input,
      wordCount: wordCount ?? this.wordCount,
      charCount: charCount ?? this.charCount,
      sentenceCount: sentenceCount ?? this.sentenceCount,
    );
  }
}

class WordCounterNotifier extends StateNotifier<WordCounterState> {
  WordCounterNotifier() : super(const WordCounterState());

  void setInput(String text) {
    state = state.copyWith(input: text);
    _processText();
  }

  void _processText() {
    final words = state.input.trim().split(RegExp(r'\s+'));
    final sentences = state.input.split(RegExp(r'[.!?]+'));
    
    state = state.copyWith(
      wordCount: words.isEmpty || words.first.isEmpty ? 0 : words.length,
      charCount: state.input.length,
      sentenceCount: sentences.isEmpty || sentences.first.isEmpty ? 0 : sentences.length,
    );
  }
}

final wordCounterProvider = StateNotifierProvider<WordCounterNotifier, WordCounterState>((ref) {
  return WordCounterNotifier();
});

// Case Converter Provider
class CaseConverterState {
  final String input;
  final String output;
  final TextCase textCase;

  const CaseConverterState({
    this.input = '',
    this.output = '',
    this.textCase = TextCase.none,
  });

  CaseConverterState copyWith({
    String? input,
    String? output,
    TextCase? textCase,
  }) {
    return CaseConverterState(
      input: input ?? this.input,
      output: output ?? this.output,
      textCase: textCase ?? this.textCase,
    );
  }
}

class CaseConverterNotifier extends StateNotifier<CaseConverterState> {
  CaseConverterNotifier() : super(const CaseConverterState());

  void setInput(String text) {
    state = state.copyWith(input: text);
    _processText();
  }

  void setTextCase(TextCase textCase) {
    state = state.copyWith(textCase: textCase);
    _processText();
  }

  void _processText() {
    String processedText = state.input;

    switch (state.textCase) {
      case TextCase.uppercase:
        processedText = processedText.toUpperCase();
        break;
      case TextCase.lowercase:
        processedText = processedText.toLowerCase();
        break;
      case TextCase.titleCase:
        processedText = processedText.split(' ').map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join(' ');
        break;
      case TextCase.sentenceCase:
        if (processedText.isNotEmpty) {
          processedText = processedText[0].toUpperCase() + processedText.substring(1).toLowerCase();
        }
        break;
      case TextCase.none:
        break;
    }

    state = state.copyWith(output: processedText);
  }
}

final caseConverterProvider = StateNotifierProvider<CaseConverterNotifier, CaseConverterState>((ref) {
  return CaseConverterNotifier();
});

// Find Replace Provider
class FindReplaceState {
  final String input;
  final String output;
  final String findText;
  final String replaceText;

  const FindReplaceState({
    this.input = '',
    this.output = '',
    this.findText = '',
    this.replaceText = '',
  });

  FindReplaceState copyWith({
    String? input,
    String? output,
    String? findText,
    String? replaceText,
  }) {
    return FindReplaceState(
      input: input ?? this.input,
      output: output ?? this.output,
      findText: findText ?? this.findText,
      replaceText: replaceText ?? this.replaceText,
    );
  }
}

class FindReplaceNotifier extends StateNotifier<FindReplaceState> {
  FindReplaceNotifier() : super(const FindReplaceState());

  void setInput(String text) {
    state = state.copyWith(input: text);
    _processText();
  }

  void setFindReplace(String find, String replace) {
    state = state.copyWith(findText: find, replaceText: replace);
    _processText();
  }

  void _processText() {
    String processedText = state.input;
    if (state.findText.isNotEmpty) {
      processedText = processedText.replaceAll(state.findText, state.replaceText);
    }
    state = state.copyWith(output: processedText);
  }
}

final findReplaceProvider = StateNotifierProvider<FindReplaceNotifier, FindReplaceState>((ref) {
  return FindReplaceNotifier();
});

// Prefix Suffix Provider
class PrefixSuffixState {
  final String input;
  final String output;
  final String prefix;
  final String suffix;
  final bool applyToWords;

  const PrefixSuffixState({
    this.input = '',
    this.output = '',
    this.prefix = '',
    this.suffix = '',
    this.applyToWords = false,
  });

  PrefixSuffixState copyWith({
    String? input,
    String? output,
    String? prefix,
    String? suffix,
    bool? applyToWords,
  }) {
    return PrefixSuffixState(
      input: input ?? this.input,
      output: output ?? this.output,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      applyToWords: applyToWords ?? this.applyToWords,
    );
  }
}

class PrefixSuffixNotifier extends StateNotifier<PrefixSuffixState> {
  PrefixSuffixNotifier() : super(const PrefixSuffixState());

  void setInput(String text) {
    state = state.copyWith(input: text);
    _processText();
  }

  void setPrefixSuffix(String prefix, String suffix, bool applyToWords) {
    state = state.copyWith(prefix: prefix, suffix: suffix, applyToWords: applyToWords);
    _processText();
  }

  void _processText() {
    String processedText = state.input;
    if (state.prefix.isNotEmpty || state.suffix.isNotEmpty) {
      if (state.applyToWords) {
        final words = processedText.split(' ');
        processedText = words.map((word) => '${state.prefix}$word${state.suffix}').join(' ');
      } else {
        processedText = '${state.prefix}$processedText${state.suffix}';
      }
    }
    state = state.copyWith(output: processedText);
  }
}

final prefixSuffixProvider = StateNotifierProvider<PrefixSuffixNotifier, PrefixSuffixState>((ref) {
  return PrefixSuffixNotifier();
});

// Remove Spaces Provider
class RemoveSpacesState {
  final String input;
  final String output;
  final bool removeExtraSpaces;
  final bool removeLeadingTrailing;

  const RemoveSpacesState({
    this.input = '',
    this.output = '',
    this.removeExtraSpaces = false,
    this.removeLeadingTrailing = false,
  });

  RemoveSpacesState copyWith({
    String? input,
    String? output,
    bool? removeExtraSpaces,
    bool? removeLeadingTrailing,
  }) {
    return RemoveSpacesState(
      input: input ?? this.input,
      output: output ?? this.output,
      removeExtraSpaces: removeExtraSpaces ?? this.removeExtraSpaces,
      removeLeadingTrailing: removeLeadingTrailing ?? this.removeLeadingTrailing,
    );
  }
}

class RemoveSpacesNotifier extends StateNotifier<RemoveSpacesState> {
  RemoveSpacesNotifier() : super(const RemoveSpacesState());

  void setInput(String text) {
    state = state.copyWith(input: text);
    _processText();
  }

  void setSpaceOptions(bool removeExtra, bool removeLeadingTrailing) {
    state = state.copyWith(
      removeExtraSpaces: removeExtra,
      removeLeadingTrailing: removeLeadingTrailing,
    );
    _processText();
  }

  void _processText() {
    String processedText = state.input;
    if (state.removeExtraSpaces) {
      processedText = processedText.replaceAll(RegExp(r'\s+'), ' ');
    }
    if (state.removeLeadingTrailing) {
      processedText = processedText.trim();
    }
    state = state.copyWith(output: processedText);
  }
}

final removeSpacesProvider = StateNotifierProvider<RemoveSpacesNotifier, RemoveSpacesState>((ref) {
  return RemoveSpacesNotifier();
});

// Reverse Text Provider
class ReverseTextState {
  final String input;
  final String output;
  final bool reverseWords;

  const ReverseTextState({
    this.input = '',
    this.output = '',
    this.reverseWords = false,
  });

  ReverseTextState copyWith({
    String? input,
    String? output,
    bool? reverseWords,
  }) {
    return ReverseTextState(
      input: input ?? this.input,
      output: output ?? this.output,
      reverseWords: reverseWords ?? this.reverseWords,
    );
  }
}

class ReverseTextNotifier extends StateNotifier<ReverseTextState> {
  ReverseTextNotifier() : super(const ReverseTextState());

  void setInput(String text) {
    state = state.copyWith(input: text);
    _processText();
  }

  void setReverseWords(bool reverseWords) {
    state = state.copyWith(reverseWords: reverseWords);
    _processText();
  }

  void _processText() {
    String processedText = state.input;
    if (state.reverseWords) {
      processedText = processedText.split(' ').reversed.join(' ');
    } else {
      processedText = processedText.split('').reversed.join('');
    }
    state = state.copyWith(output: processedText);
  }
}

final reverseTextProvider = StateNotifierProvider<ReverseTextNotifier, ReverseTextState>((ref) {
  return ReverseTextNotifier();
});

// Repeat Text Provider
class RepeatTextState {
  final String input;
  final String output;
  final int repeatCount;
  final bool addSeparator;
  final String separator;

  const RepeatTextState({
    this.input = '',
    this.output = '',
    this.repeatCount = 1,
    this.addSeparator = false,
    this.separator = '',
  });

  RepeatTextState copyWith({
    String? input,
    String? output,
    int? repeatCount,
    bool? addSeparator,
    String? separator,
  }) {
    return RepeatTextState(
      input: input ?? this.input,
      output: output ?? this.output,
      repeatCount: repeatCount ?? this.repeatCount,
      addSeparator: addSeparator ?? this.addSeparator,
      separator: separator ?? this.separator,
    );
  }
}

class RepeatTextNotifier extends StateNotifier<RepeatTextState> {
  RepeatTextNotifier() : super(const RepeatTextState());

  void setInput(String text) {
    state = state.copyWith(input: text);
    _processText();
  }

  void setRepeatCount(int count) {
    state = state.copyWith(repeatCount: count);
    _processText();
  }

  void setSeparator(bool addSeparator, String separator) {
    state = state.copyWith(addSeparator: addSeparator, separator: separator);
    _processText();
  }

  void _processText() {
    String processedText = state.input;
    if (state.repeatCount > 1) {
      final separator = state.addSeparator ? state.separator : '';
      processedText = List.filled(state.repeatCount, processedText).join(separator);
    }
    state = state.copyWith(output: processedText);
  }
}

final repeatTextProvider = StateNotifierProvider<RepeatTextNotifier, RepeatTextState>((ref) {
  return RepeatTextNotifier();
}); 