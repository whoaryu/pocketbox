import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAnalysis {
  final int wordCount;
  final int characterCount;
  final int sentenceCount;

  const TextAnalysis({
    required this.wordCount,
    required this.characterCount,
    required this.sentenceCount,
  });
}

class TextAnalysisNotifier extends StateNotifier<TextAnalysis> {
  TextAnalysisNotifier()
      : super(const TextAnalysis(
          wordCount: 0,
          characterCount: 0,
          sentenceCount: 0,
        ));

  void analyzeText(String text) {
    if (text.isEmpty) {
      state = const TextAnalysis(
        wordCount: 0,
        characterCount: 0,
        sentenceCount: 0,
      );
      return;
    }

    // Count words (split by whitespace and filter out empty strings)
    final words = text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
    
    // Count characters (excluding whitespace)
    final characters = text.replaceAll(RegExp(r'\s+'), '').length;
    
    // Count sentences (split by common sentence endings)
    final sentences = text.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).length;

    state = TextAnalysis(
      wordCount: words,
      characterCount: characters,
      sentenceCount: sentences,
    );
  }
}

final textAnalysisProvider =
    StateNotifierProvider<TextAnalysisNotifier, TextAnalysis>((ref) {
  return TextAnalysisNotifier();
}); 