import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EditorTool {
  none,
  adjust,
  filter,
  crop,
  layers,
  brush,
  text,
  heal,
  transform
}

class EditorState {
  final ui.Image? image;
  final EditorTool activeTool;
  final List<ui.Image> history;
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
    List<ui.Image>? history,
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
    state = state.copyWith(
      image: image,
      history: [image],
      historyIndex: 0,
    );
  }

  void setActiveTool(EditorTool tool) {
    if (state.activeTool == tool) {
      state = state.copyWith(activeTool: EditorTool.none);
    } else {
      state = state.copyWith(activeTool: tool);
    }
  }

  void setBeforeView(bool value) {
    state = state.copyWith(isBeforeView: value);
  }

  void pushHistory(ui.Image newImage) {
    final newHistory = state.history.sublist(0, state.historyIndex + 1);
    newHistory.add(newImage);
    
    // Limit history to 30 steps
    if (newHistory.length > 30) {
      newHistory.removeAt(0);
    }

    state = state.copyWith(
      image: newImage,
      history: newHistory,
      historyIndex: newHistory.length - 1,
    );
  }

  void undo() {
    if (state.historyIndex > 0) {
      final newIndex = state.historyIndex - 1;
      state = state.copyWith(
        image: state.history[newIndex],
        historyIndex: newIndex,
      );
    }
  }

  void redo() {
    if (state.historyIndex < state.history.length - 1) {
      final newIndex = state.historyIndex + 1;
      state = state.copyWith(
        image: state.history[newIndex],
        historyIndex: newIndex,
      );
    }
  }

  bool get canUndo => state.historyIndex > 0;
  bool get canRedo => state.historyIndex < state.history.length - 1;
}
