import 'dart:math';
import 'package:flutter/material.dart';

enum AspectRatio { free, square, fourThree, threeTwo, sixteenNine, nineToSixteen }

class CropTool extends StatefulWidget {
  final Size imageSize;
  final Function(Rect, double) onCropApplied;
  final VoidCallback onCancel;

  const CropTool({super.key, required this.imageSize, required this.onCropApplied, required this.onCancel});

  @override
  State<CropTool> createState() => _CropToolState();
}

class _CropToolState extends State<CropTool> {
  late Rect _cropRect;
  AspectRatio _aspectRatio = AspectRatio.free;
  double _rotation = 0.0;
  static const double _handleSize = 20.0;
  String? _draggingHandle; // 'tl','tr','bl','br','t','b','l','r'

  @override
  void initState() {
    super.initState();
    _cropRect = Rect.fromLTWH(
      widget.imageSize.width * 0.1,
      widget.imageSize.height * 0.1,
      widget.imageSize.width * 0.8,
      widget.imageSize.height * 0.8,
    );
  }

  double? get _lockedRatio {
    switch (_aspectRatio) {
      case AspectRatio.square: return 1.0;
      case AspectRatio.fourThree: return 4 / 3;
      case AspectRatio.threeTwo: return 3 / 2;
      case AspectRatio.sixteenNine: return 16 / 9;
      case AspectRatio.nineToSixteen: return 9 / 16;
      default: return null;
    }
  }

  void _onPanStart(DragStartDetails d, String handle) {
    setState(() => _draggingHandle = handle);
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_draggingHandle == null) return;
    final dx = d.delta.dx;
    final dy = d.delta.dy;
    double l = _cropRect.left, t = _cropRect.top, r = _cropRect.right, b = _cropRect.bottom;
    const minSize = 40.0;

    switch (_draggingHandle) {
      case 'tl': l += dx; t += dy; break;
      case 'tr': r += dx; t += dy; break;
      case 'bl': l += dx; b += dy; break;
      case 'br': r += dx; b += dy; break;
      case 't': t += dy; break;
      case 'b': b += dy; break;
      case 'l': l += dx; break;
      case 'r': r += dx; break;
    }

    // Clamp to image bounds
    l = l.clamp(0, r - minSize);
    t = t.clamp(0, b - minSize);
    r = r.clamp(l + minSize, widget.imageSize.width);
    b = b.clamp(t + minSize, widget.imageSize.height);

    // Enforce aspect ratio if locked
    final ratio = _lockedRatio;
    if (ratio != null) {
      final w = r - l;
      final h = w / ratio;
      b = t + h;
      if (b > widget.imageSize.height) {
        b = widget.imageSize.height;
        final newH = b - t;
        r = l + newH * ratio;
      }
    }

    setState(() => _cropRect = Rect.fromLTRB(l, t, r, b));
  }

  void _setAspectRatio(AspectRatio ratio) {
    setState(() {
      _aspectRatio = ratio;
      // Re-apply ratio to current rect
      final r = _lockedRatio;
      if (r != null) {
        final w = _cropRect.width;
        final h = w / r;
        _cropRect = Rect.fromLTWH(_cropRect.left, _cropRect.top, w, h.clamp(40, widget.imageSize.height - _cropRect.top));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Scale cropRect to screen coords for display
      final scaleX = constraints.maxWidth / widget.imageSize.width;
      final scaleY = constraints.maxHeight / widget.imageSize.height;
      final displayRect = Rect.fromLTWH(
        _cropRect.left * scaleX,
        _cropRect.top * scaleY,
        _cropRect.width * scaleX,
        _cropRect.height * scaleY,
      );

      return Stack(
        children: [
          // Darkened overlay outside crop
          CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _CropOverlayPainter(cropRect: displayRect),
          ),

          // Corner handles
          for (final entry in {
            'tl': Offset(displayRect.left, displayRect.top),
            'tr': Offset(displayRect.right, displayRect.top),
            'bl': Offset(displayRect.left, displayRect.bottom),
            'br': Offset(displayRect.right, displayRect.bottom),
            't': Offset(displayRect.center.dx, displayRect.top),
            'b': Offset(displayRect.center.dx, displayRect.bottom),
            'l': Offset(displayRect.left, displayRect.center.dy),
            'r': Offset(displayRect.right, displayRect.center.dy),
          }.entries)
            Positioned(
              left: entry.value.dx - _handleSize / 2,
              top: entry.value.dy - _handleSize / 2,
              child: GestureDetector(
                onPanStart: (d) => _onPanStart(d, entry.key),
                onPanUpdate: _onPanUpdate,
                onPanEnd: (_) => setState(() => _draggingHandle = null),
                child: Container(
                  width: _handleSize,
                  height: _handleSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.black54)],
                  ),
                ),
              ),
            ),

          // Aspect ratio presets
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  for (final r in AspectRatio.values)
                    _AspectButton(
                      label: _aspectLabel(r),
                      isSelected: _aspectRatio == r,
                      onTap: () => _setAspectRatio(r),
                    ),
                ],
              ),
            ),
          ),

          // Rotation slider
          Positioned(
            bottom: 60,
            left: 32,
            right: 32,
            child: Row(
              children: [
                const Icon(Icons.rotate_left, color: Colors.white54, size: 18),
                Expanded(
                  child: SliderTheme(
                    data: const SliderThemeData(
                      activeTrackColor: Color(0xFFFF6B35),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      trackHeight: 2,
                    ),
                    child: Slider(
                      value: _rotation,
                      min: -45,
                      max: 45,
                      onChanged: (v) => setState(() => _rotation = v),
                    ),
                  ),
                ),
                const Icon(Icons.rotate_right, color: Colors.white54, size: 18),
              ],
            ),
          ),

          // Cancel / Apply buttons
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
                  onPressed: () => widget.onCropApplied(_cropRect, _rotation),
                  child: const Text('Apply', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  String _aspectLabel(AspectRatio r) {
    switch (r) {
      case AspectRatio.free: return 'Free';
      case AspectRatio.square: return '1:1';
      case AspectRatio.fourThree: return '4:3';
      case AspectRatio.threeTwo: return '3:2';
      case AspectRatio.sixteenNine: return '16:9';
      case AspectRatio.nineToSixteen: return '9:16';
    }
  }
}

class _CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  _CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Paint()..color = Colors.black.withValues(alpha: 0.55);
    // Draw 4 rects around the crop area
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, cropRect.top), overlay);
    canvas.drawRect(Rect.fromLTRB(0, cropRect.bottom, size.width, size.height), overlay);
    canvas.drawRect(Rect.fromLTRB(0, cropRect.top, cropRect.left, cropRect.bottom), overlay);
    canvas.drawRect(Rect.fromLTRB(cropRect.right, cropRect.top, size.width, cropRect.bottom), overlay);

    // Rule of thirds grid
    final gridPaint = Paint()..color = Colors.white.withValues(alpha: 0.25)..strokeWidth = 0.5;
    for (int i = 1; i < 3; i++) {
      final x = cropRect.left + cropRect.width * i / 3;
      final y = cropRect.top + cropRect.height * i / 3;
      canvas.drawLine(Offset(x, cropRect.top), Offset(x, cropRect.bottom), gridPaint);
      canvas.drawLine(Offset(cropRect.left, y), Offset(cropRect.right, y), gridPaint);
    }

    // Border
    final borderPaint = Paint()..color = Colors.white..strokeWidth = 1.5..style = PaintingStyle.stroke;
    canvas.drawRect(cropRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter old) => old.cropRect != cropRect;
}

class _AspectButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AspectButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.white10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label, style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        )),
      ),
    );
  }
}
