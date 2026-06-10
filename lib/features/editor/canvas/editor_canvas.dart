import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import '../../../models/adjustment_model.dart';
import '../../../providers/layers_provider.dart';
import '../../../providers/image_cache_provider.dart';
import '../../../providers/interaction_provider.dart';
import 'canvas_controller.dart';
import 'canvas_painter.dart';

class EditorCanvas extends ConsumerStatefulWidget {
  final CanvasController controller;
  final AdjustmentModel adjustments;

  const EditorCanvas({
    super.key,
    required this.controller,
    required this.adjustments,
  });

  @override
  ConsumerState<EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends ConsumerState<EditorCanvas> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final layers = ref.watch(layersProvider);
    final images = ref.watch(imageCacheProvider);
    final isInteracting = ref.watch(isSliderInteractingProvider);

    return XGestureDetector(
      onMoveUpdate: (details) {
        widget.controller.updateTransform(
          offset: widget.controller.offset + details.delta,
        );
      },
      onScaleUpdate: (details) {
        widget.controller.updateTransform(
          scale: widget.controller.scale * details.scale,
        );
      },
      onDoubleTap: (details) {
        widget.controller.reset();
      },
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: CanvasPainter(
            images: images,
            layers: layers,
            offset: widget.controller.offset,
            scale: widget.controller.scale,
            rotation: widget.controller.rotation,
            adjustments: widget.adjustments,
            isInteracting: isInteracting,
          ),
        ),
      ),
    );
  }
}
