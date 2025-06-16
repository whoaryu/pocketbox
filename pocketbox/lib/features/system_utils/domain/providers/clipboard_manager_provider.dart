import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:pocketbox/features/system_utils/data/database_helper.dart';

class ClipboardItem {
  final int id;
  final String content;
  final DateTime timestamp;
  final bool isFavorite;

  const ClipboardItem({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFavorite,
  });
}

class ClipboardManagerState {
  final List<ClipboardItem> clips;
  final String? currentClip;
  final bool isLoading;

  const ClipboardManagerState({
    this.clips = const [],
    this.currentClip,
    this.isLoading = false,
  });

  ClipboardManagerState copyWith({
    List<ClipboardItem>? clips,
    String? currentClip,
    bool? isLoading,
  }) {
    return ClipboardManagerState(
      clips: clips ?? this.clips,
      currentClip: currentClip ?? this.currentClip,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ClipboardManagerNotifier extends StateNotifier<ClipboardManagerState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  ClipboardManagerNotifier() : super(const ClipboardManagerState()) {
    _loadClips();
  }

  Future<void> _loadClips() async {
    state = state.copyWith(isLoading: true);
    try {
      final clips = await _dbHelper.getClips();
      state = state.copyWith(
        clips: clips.map((clip) => ClipboardItem(
          id: clip['id'] as int,
          content: clip['content'] as String,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            clip['timestamp'] as int,
          ),
          isFavorite: (clip['is_favorite'] as int) == 1,
        )).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> checkClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clipboardData?.text;
      if (text != null && text.isNotEmpty) {
        state = state.copyWith(currentClip: text);
        await _dbHelper.insertClip(text);
        await _loadClips();
      }
    } catch (e) {
      // Handle clipboard access error
    }
  }

  Future<void> toggleFavorite(int id) async {
    await _dbHelper.toggleFavorite(id);
    await _loadClips();
  }

  Future<void> deleteClip(int id) async {
    await _dbHelper.deleteClip(id);
    await _loadClips();
  }

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    await _dbHelper.insertClip(text);
    await _loadClips();
  }
}

final clipboardManagerProvider =
    StateNotifierProvider<ClipboardManagerNotifier, ClipboardManagerState>((ref) {
  return ClipboardManagerNotifier();
}); 