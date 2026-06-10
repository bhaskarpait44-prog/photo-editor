import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/adjustment_model.dart';

enum EditorTool { none, adjust, filter, crop, layers, brush, text, heal, transform, hsl }

// Command pattern — each history entry stores adjustment state, NOT bitmap
class HistoryEntry {
  final AdjustmentModel adjustments;
  final String description;
  HistoryEntry({required this.adjustments, required this.description});
}

class EditorState {
  final ui.Image? image;
  final EditorTool activeTool;
  final List<HistoryEntry> history;
  final int historyIndex;
  final bool isBeforeView;

  EditorState({
    this.image,
    this.activeTool = EditorTool.none,
    this.history = const [],
    this.historyIndex = -1,
    this.isBeforeView = false,
  });

  EditorState copyWith({
    ui.Image? image,
    EditorTool? activeTool,
    List<HistoryEntry>? history,
    int? historyIndex,
    bool? isBeforeView,
  }) {
    return EditorState(
      image: image ?? this.image,
      activeTool: activeTool ?? this.activeTool,
      history: history ?? this.history,
      historyIndex: historyIndex ?? this.historyIndex,
      isBeforeView: isBeforeView ?? this.isBeforeView,
    );
  }
}

final editorProvider = StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  return EditorNotifier();
});

class EditorNotifier extends StateNotifier<EditorState> {
  EditorNotifier() : super(EditorState());

  void setImage(ui.Image image) {
    state = state.copyWith(image: image, history: [], historyIndex: -1);
  }

  void setActiveTool(EditorTool tool) {
    state = state.copyWith(activeTool: state.activeTool == tool ? EditorTool.none : tool);
  }

  void setBeforeView(bool value) => state = state.copyWith(isBeforeView: value);

  // Call this AFTER the user finishes a slider drag (onChangeEnd), not during
  void pushHistory(AdjustmentModel adjustments, {String description = 'Edit'}) {
    final newHistory = state.history.sublist(0, state.historyIndex + 1);
    newHistory.add(HistoryEntry(adjustments: adjustments, description: description));
    if (newHistory.length > 50) newHistory.removeAt(0);
    state = state.copyWith(history: newHistory, historyIndex: newHistory.length - 1);
  }

  void undo(void Function(AdjustmentModel) onRestore) {
    if (state.historyIndex > 0) {
      final newIndex = state.historyIndex - 1;
      state = state.copyWith(historyIndex: newIndex);
      onRestore(state.history[newIndex].adjustments);
    } else if (state.historyIndex == 0) {
      const newIndex = -1;
      state = state.copyWith(historyIndex: newIndex);
      onRestore(const AdjustmentModel());
    }
  }

  void redo(void Function(AdjustmentModel) onRestore) {
    if (state.historyIndex < state.history.length - 1) {
      final newIndex = state.historyIndex + 1;
      state = state.copyWith(historyIndex: newIndex);
      onRestore(state.history[newIndex].adjustments);
    }
  }

  bool get canUndo => state.historyIndex >= 0;
  bool get canRedo => state.historyIndex < state.history.length - 1;
}

final isHistogramVisibleProvider = StateProvider<bool>((ref) => false);
