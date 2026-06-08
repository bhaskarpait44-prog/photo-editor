import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/layer_model.dart';

final layersProvider = StateNotifierProvider<LayersNotifier, List<LayerModel>>((ref) {
  return LayersNotifier();
});

final activeLayerIdProvider = StateProvider<String?>((ref) => null);

class LayersNotifier extends StateNotifier<List<LayerModel>> {
  LayersNotifier() : super([]);

  void addLayer(LayerModel layer) {
    state = [...state, layer];
  }

  void removeLayer(String id) {
    state = state.where((l) => l.id != id).toList();
  }

  void updateLayer(LayerModel updatedLayer) {
    state = [
      for (final layer in state)
        if (layer.id == updatedLayer.id) updatedLayer else layer
    ];
  }

  void reorderLayers(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final list = [...state];
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = list;
  }

  void duplicateLayer(String id) {
    final index = state.indexWhere((l) => l.id == id);
    if (index != -1) {
      final original = state[index];
      final duplicate = original.copyWith(
        id: const Uuid().v4(),
        name: '${original.name} Copy',
      );
      state = [...state]..insert(index + 1, duplicate);
    }
  }
}
