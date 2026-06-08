import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SelectionMode { add, subtract, intersect, replace }

class SelectionState {
  final Path? selectionPath;
  final SelectionMode mode;

  SelectionState({this.selectionPath, this.mode = SelectionMode.replace});

  SelectionState copyWith({Path? selectionPath, SelectionMode? mode}) {
    return SelectionState(
      selectionPath: selectionPath ?? this.selectionPath,
      mode: mode ?? this.mode,
    );
  }
}

final selectionProvider = StateNotifierProvider<SelectionNotifier, SelectionState>((ref) {
  return SelectionNotifier();
});

class SelectionNotifier extends StateNotifier<SelectionState> {
  SelectionNotifier() : super(SelectionState());

  void setPath(Path path) {
    state = state.copyWith(selectionPath: path);
  }

  void clear() {
    state = SelectionState();
  }
}
