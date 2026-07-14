import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/selection_provider.dart';

enum SelectionToolMode { rectangle, lasso }

final selectionToolModeProvider = StateProvider<SelectionToolMode>((ref) => SelectionToolMode.rectangle);

class SelectionToolOverlay extends ConsumerStatefulWidget {
  const SelectionToolOverlay({super.key});
  @override
  ConsumerState<SelectionToolOverlay> createState() => _SelectionToolOverlayState();
}

class _SelectionToolOverlayState extends ConsumerState<SelectionToolOverlay> {
  Offset? _startPos;
  Offset? _currentPos;
  List<Offset> _lassoPoints = [];
  bool _isDrawing = false;

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(selectionToolModeProvider);
    final selectionPath = ref.watch(selectionProvider).selectionPath;

    return GestureDetector(
      onPanStart: (d) {
        setState(() {
          _isDrawing = true;
          _startPos = d.localPosition;
          _currentPos = d.localPosition;
          if (mode == SelectionToolMode.lasso) {
            _lassoPoints = [d.localPosition];
          }
        });
      },
      onPanUpdate: (d) {
        setState(() {
          _currentPos = d.localPosition;
          if (mode == SelectionToolMode.lasso) {
            _lassoPoints.add(d.localPosition);
          }
        });
      },
      onPanEnd: (_) {
        if (_startPos != null && _currentPos != null) {
          Path path;
          if (mode == SelectionToolMode.rectangle) {
            final rect = Rect.fromPoints(_startPos!, _currentPos!);
            path = Path()..addRect(rect);
          } else {
            path = Path()..moveTo(_lassoPoints.first.dx, _lassoPoints.first.dy);
            for (final pt in _lassoPoints.skip(1)) {
              path.lineTo(pt.dx, pt.dy);
            }
            path.close();
          }
          ref.read(selectionProvider.notifier).setPath(path);
        }
        setState(() { _isDrawing = false; _startPos = null; _currentPos = null; _lassoPoints = []; });
      },
      behavior: HitTestBehavior.translucent,
      child: CustomPaint(
        size: Size.infinite,
        painter: _SelectionPainter(
          mode: mode,
          startPos: _startPos,
          currentPos: _currentPos,
          lassoPoints: _lassoPoints,
          isDrawing: _isDrawing,
          existingPath: selectionPath,
        ),
      ),
    );
  }
}

class _SelectionPainter extends CustomPainter {
  final SelectionToolMode mode;
  final Offset? startPos;
  final Offset? currentPos;
  final List<Offset> lassoPoints;
  final bool isDrawing;
  final Path? existingPath;

  const _SelectionPainter({
    required this.mode,
    required this.startPos,
    required this.currentPos,
    required this.lassoPoints,
    required this.isDrawing,
    required this.existingPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw existing selection
    if (existingPath != null && !isDrawing) {
      // Marching ants effect (simplified: dashed white line)
      final dashPaint = Paint()..color = Colors.white..strokeWidth = 1.5..style = PaintingStyle.stroke;
      canvas.drawPath(existingPath!, dashPaint);
      // Draw dimmed interior overlay
      canvas.drawPath(existingPath!, Paint()..color = Colors.blue.withValues(alpha: 0.1));
    }

    if (!isDrawing || startPos == null || currentPos == null) return;

    if (mode == SelectionToolMode.rectangle) {
      canvas.drawRect(Rect.fromPoints(startPos!, currentPos!), paint);
    } else if (lassoPoints.length > 1) {
      final path = Path()..moveTo(lassoPoints.first.dx, lassoPoints.first.dy);
      for (final pt in lassoPoints.skip(1)) path.lineTo(pt.dx, pt.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter old) => true;
}
