import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../models/layer_model.dart';
import '../../../models/text_settings_model.dart';
import '../../../providers/layers_provider.dart';
import '../../../providers/editor_provider.dart';

class TextToolOverlay extends ConsumerStatefulWidget {
  const TextToolOverlay({super.key});

  @override
  ConsumerState<TextToolOverlay> createState() => _TextToolOverlayState();
}

class _TextToolOverlayState extends ConsumerState<TextToolOverlay> {
  Offset? _tapPosition;
  final TextEditingController _textController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (_isEditing) { _finalizeText(); return; }
    setState(() {
      _tapPosition = details.localPosition;
      _isEditing = true;
      _textController.clear();
    });
  }

  void _finalizeText() {
    if (_textController.text.trim().isEmpty) {
      setState(() => _isEditing = false);
      return;
    }
    final id = const Uuid().v4();
    final layer = LayerModel(
      id: id, name: 'Text',
      type: LayerType.text,
      offsetX: _tapPosition?.dx ?? 0,
      offsetY: _tapPosition?.dy ?? 0,
      textSettings: TextSettingsModel(text: _textController.text),
    );
    ref.read(layersProvider.notifier).addLayer(layer);
    ref.read(activeLayerIdProvider.notifier).state = id;
    setState(() { _isEditing = false; _textController.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          if (_isEditing && _tapPosition != null)
            Positioned(
              left: _tapPosition!.dx,
              top: _tapPosition!.dy,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 280),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFF6B35), width: 1),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black54,
                  ),
                  child: IntrinsicWidth(
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        border: InputBorder.none, isDense: true,
                        hintText: 'Type here...',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                      onSubmitted: (_) => _finalizeText(),
                    ),
                  ),
                ),
              ),
            ),
          if (_isEditing)
            Positioned(
              bottom: 16, right: 16,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() { _isEditing = false; _textController.clear(); }),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _finalizeText,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
                    child: const Text('Done', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
