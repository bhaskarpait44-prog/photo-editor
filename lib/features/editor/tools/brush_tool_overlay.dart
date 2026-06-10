import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/brush_settings_model.dart';
import '../../../providers/brush_provider.dart';

class BrushToolOverlay extends ConsumerStatefulWidget {
  final Size imageSize;
  final Function(ui.Image) onStrokeEnd;

  const BrushToolOverlay({
    super.key,
    required this.imageSize,
    required this.onStrokeEnd,
  });

  @override
  ConsumerState<BrushToolOverlay> createState() => _BrushToolOverlayState();
}

class _BrushToolOverlayState extends ConsumerState<BrushToolOverlay> {
  final List<Offset> _currentPoints = [];
  ui.Image? _strokeImage;
  Offset? _hoverPos;

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentPoints.clear();
      _currentPoints.add(details.localPosition);
      _hoverPos = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPoints.add(details.localPosition);
      _hoverPos = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    setState(() {
      _hoverPos = null;
    });

    if (_currentPoints.length < 2) return;

    final settings = ref.read(brushSettingsProvider);
    final isEraser = ref.read(isEraserModeProvider);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Apply smoothing and draw
    _drawSmoothedStroke(canvas, _currentPoints, settings, isEraser);

    final picture = recorder.endRecording();
    final image = await picture.toImage(widget.imageSize.width.toInt(), widget.imageSize.height.toInt());
    
    widget.onStrokeEnd(image);
    setState(() {
      _currentPoints.clear();
    });
  }

  void _drawSmoothedStroke(Canvas canvas, List<Offset> points, BrushSettingsModel settings, bool isEraser) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = isEraser ? Colors.transparent : settings.color.withValues(alpha: settings.opacity)
      ..blendMode = isEraser ? BlendMode.clear : BlendMode.srcOver
      ..style = PaintingStyle.fill;

    // Hardness fallback to solid if hardness is 1.0
    if (settings.hardness < 1.0) {
      final List<Color> colors = [paint.color, paint.color.withValues(alpha: 0)];
      final List<double> stops = [settings.hardness, 1.0];
      // Gradients will be handled by drawing radial gradients along the path
      // Note: this is expensive. For true Catmull-Rom with soft brushes,
      // it's typically stamped along the path.
      
      final step = settings.size * settings.spacing;
      double dist = 0.0;
      
      for (int i = 0; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        final d = (p2 - p1).distance;
        
        while (dist <= d) {
          final p = Offset.lerp(p1, p2, dist / d)!;
          paint.shader = ui.Gradient.radial(
            p,
            settings.size / 2,
            colors,
            stops,
          );
          canvas.drawCircle(p, settings.size / 2, paint);
          dist += step;
        }
        dist -= d;
      }
    } else {
      // Solid stroke
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      // Basic smoothing for solid
      for (int i = 1; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        final cp = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
        path.quadraticBezierTo(p1.dx, p1.dy, cp.dx, cp.dy);
      }
      path.lineTo(points.last.dx, points.last.dy);
      
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = settings.size;
      paint.strokeCap = StrokeCap.round;
      paint.strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final scaleX = widget.imageSize.width / constraints.maxWidth;
      final scaleY = widget.imageSize.height / constraints.maxHeight;

      return GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _BrushPreviewPainter(
            hoverPos: _hoverPos,
            points: _currentPoints,
            settings: ref.watch(brushSettingsProvider),
            isEraser: ref.watch(isEraserModeProvider),
            scaleX: scaleX,
            scaleY: scaleY,
          ),
        ),
      );
    });
  }
}

class _BrushPreviewPainter extends CustomPainter {
  final Offset? hoverPos;
  final List<Offset> points;
  final BrushSettingsModel settings;
  final bool isEraser;
  final double scaleX;
  final double scaleY;

  _BrushPreviewPainter({
    required this.hoverPos,
    required this.points,
    required this.settings,
    required this.isEraser,
    required this.scaleX,
    required this.scaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        final cp = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
        path.quadraticBezierTo(p1.dx, p1.dy, cp.dx, cp.dy);
      }
      path.lineTo(points.last.dx, points.last.dy);

      final paint = Paint()
        ..color = isEraser ? Colors.white54 : settings.color.withValues(alpha: settings.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = settings.size / ((scaleX + scaleY) / 2)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      canvas.drawPath(path, paint);
    }

    if (hoverPos != null) {
      final r = settings.size / ((scaleX + scaleY) / 2) / 2;
      canvas.drawCircle(hoverPos!, r, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1);
    }
  }

  @override
  bool shouldRepaint(covariant _BrushPreviewPainter old) => true;
}
