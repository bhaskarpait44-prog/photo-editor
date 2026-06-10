import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/histogram_provider.dart';
import '../../../providers/editor_provider.dart';
import '../../../services/histogram_service.dart';

class HistogramPanel extends ConsumerStatefulWidget {
  const HistogramPanel({super.key});

  @override
  ConsumerState<HistogramPanel> createState() => _HistogramPanelState();
}

class _HistogramPanelState extends ConsumerState<HistogramPanel> {
  bool showR = true;
  bool showG = true;
  bool showB = true;
  bool showL = true;

  @override
  Widget build(BuildContext context) {
    final histogramAsync = ref.watch(histogramProvider);
    final editorState = ref.watch(editorProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ToggleBtn('R', Colors.red, showR, (v) => setState(() => showR = v)),
              _ToggleBtn('G', Colors.green, showG, (v) => setState(() => showG = v)),
              _ToggleBtn('B', Colors.blue, showB, (v) => setState(() => showB = v)),
              _ToggleBtn('L', Colors.white, showL, (v) => setState(() => showL = v)),
            ],
          ),
          const SizedBox(height: 16),
          histogramAsync.when(
            data: (data) {
              if (data == null) return const SizedBox(height: 120, child: Center(child: Text('No image data', style: TextStyle(color: Colors.white38))));
              return Column(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: CustomPaint(
                      painter: HistogramPainter(
                        data: data,
                        showR: showR,
                        showG: showG,
                        showB: showB,
                        showL: showL,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (editorState.image != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoText('${editorState.image!.width} x ${editorState.image!.height} px'),
                        _buildInfoText('${(editorState.image!.width * editorState.image!.height / 1000000).toStringAsFixed(1)} MP'),
                      ],
                    ),
                ],
              );
            },
            loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35), strokeWidth: 2))),
            error: (err, _) => SizedBox(height: 120, child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red, fontSize: 10)))),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(text, style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 0.5));
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final Function(bool) onChanged;

  const _ToggleBtn(this.label, this.color, this.isSelected, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? color : Colors.white10),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? color : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class HistogramPainter extends CustomPainter {
  final HistogramData data;
  final bool showR, showG, showB, showL;

  HistogramPainter({required this.data, required this.showR, required this.showG, required this.showB, required this.showL});

  @override
  void paint(Canvas canvas, Size size) {
    final maxCount = _getMax();
    if (maxCount == 0) return;

    final logMax = log(maxCount + 1);

    if (showR) _drawChannel(canvas, size, data.red, Colors.red, logMax);
    if (showG) _drawChannel(canvas, size, data.green, Colors.green, logMax);
    if (showB) _drawChannel(canvas, size, data.blue, Colors.blue, logMax);
    if (showL) _drawChannel(canvas, size, data.luminance, Colors.white, logMax);
  }

  int _getMax() {
    int maxV = 0;
    if (showR) {
      for (var v in data.red) {
        if (v > maxV) maxV = v;
      }
    }
    if (showG) {
      for (var v in data.green) {
        if (v > maxV) maxV = v;
      }
    }
    if (showB) {
      for (var v in data.blue) {
        if (v > maxV) maxV = v;
      }
    }
    if (showL) {
      for (var v in data.luminance) {
        if (v > maxV) maxV = v;
      }
    }
    return maxV;
  }

  void _drawChannel(Canvas canvas, Size size, Uint32List channel, Color color, double logMax) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (int i = 0; i < 256; i++) {
      final x = i * size.width / 255;
      final count = channel[i];
      final normalizedHeight = log(count + 1) / logMax;
      final y = size.height - (normalizedHeight * size.height);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
    
    // Draw outline
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    final strokePath = Path();
    strokePath.moveTo(0, size.height);
    for (int i = 0; i < 256; i++) {
      final x = i * size.width / 255;
      final normalizedHeight = log(channel[i] + 1) / logMax;
      final y = size.height - (normalizedHeight * size.height);
      strokePath.lineTo(x, y);
    }
    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
