import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/curves_model.dart';
import '../../../providers/curves_provider.dart';

class CurvesPanel extends ConsumerStatefulWidget {
  const CurvesPanel({super.key});
  @override
  ConsumerState<CurvesPanel> createState() => _CurvesPanelState();
}

class _CurvesPanelState extends ConsumerState<CurvesPanel> {
  String _activeChannel = 'rgb'; // 'rgb', 'r', 'g', 'b'
  int? _dragIndex;

  List<CurvePoint> _getPoints(CurvesState state) {
    switch (_activeChannel) {
      case 'r': return state.red;
      case 'g': return state.green;
      case 'b': return state.blue;
      default: return state.rgb;
    }
  }

  Color get _channelColor {
    switch (_activeChannel) {
      case 'r': return Colors.red;
      case 'g': return Colors.green;
      case 'b': return Colors.blue;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final curvesState = ref.watch(curvesProvider);
    final notifier = ref.read(curvesProvider.notifier);
    final points = _getPoints(curvesState);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Channel tabs
          Row(
            children: [
              for (final ch in ['rgb', 'r', 'g', 'b'])
                _ChannelTab(
                  label: ch.toUpperCase(),
                  isSelected: _activeChannel == ch,
                  color: ch == 'rgb' ? Colors.white : (ch == 'r' ? Colors.red : ch == 'g' ? Colors.green : Colors.blue),
                  onTap: () => setState(() => _activeChannel = ch),
                ),
              const Spacer(),
              TextButton(
                onPressed: () => notifier.resetChannel(_activeChannel),
                child: const Text('Reset', style: TextStyle(color: Colors.white38, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Curve editor
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white10),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapDown: (d) {
                      final size = constraints.maxWidth;
                      final x = (d.localPosition.dx / size).clamp(0.0, 1.0);
                      final y = (1.0 - d.localPosition.dy / size).clamp(0.0, 1.0);
                      notifier.addPoint(_activeChannel, CurvePoint(x, y));
                    },
                    onPanStart: (d) {
                      final pts = _getPoints(ref.read(curvesProvider));
                      final size = constraints.maxWidth;
                      for (int i = 0; i < pts.length; i++) {
                        final px = pts[i].x * size;
                        final py = (1 - pts[i].y) * size;
                        if ((Offset(px, py) - d.localPosition).distance < 24) {
                          setState(() => _dragIndex = i);
                          break;
                        }
                      }
                    },
                    onPanUpdate: (d) {
                      if (_dragIndex == null) return;
                      final size = constraints.maxWidth;
                      final x = (d.localPosition.dx / size).clamp(0.0, 1.0);
                      final y = (1.0 - d.localPosition.dy / size).clamp(0.0, 1.0);
                      notifier.movePoint(_activeChannel, _dragIndex!, CurvePoint(x, y));
                    },
                    onPanEnd: (_) => setState(() => _dragIndex = null),
                    child: CustomPaint(
                      painter: _CurvePainter(
                        points: points,
                        color: _channelColor,
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Instructions
          const Center(
            child: Text(
              'Tap to add points • Drag to move • Drag off curve to delete',
              style: TextStyle(color: Colors.white24, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          // Reset all button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: notifier.resetAll,
              child: const Text('Reset All Channels', style: TextStyle(color: Color(0xFFFF6B35))),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _ChannelTab({required this.label, required this.isSelected, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isSelected ? color : Colors.white10),
      ),
      child: Text(label, style: TextStyle(
        color: isSelected ? color : Colors.white38,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      )),
    ),
  );
}

class _CurvePainter extends CustomPainter {
  final List<CurvePoint> points;
  final Color color;

  const _CurvePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Background grid
    final gridPaint = Paint()..color = Colors.white10..strokeWidth = 0.5;
    for (int i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      final y = size.height * i / 4;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Diagonal reference line
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0),
      Paint()..color = Colors.white12..strokeWidth = 0.5);

    if (points.length < 2) return;

    // Draw curve using linear interpolation through points
    final curvePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final lut = CurvesNotifier.generateLUT(points);
    path.moveTo(0, size.height * (1 - lut[0]));
    for (int i = 1; i < 256; i++) {
      path.lineTo(size.width * i / 255, size.height * (1 - lut[i]));
    }
    canvas.drawPath(path, curvePaint);

    // Draw control points
    for (final pt in points) {
      final px = size.width * pt.x;
      final py = size.height * (1 - pt.y);
      canvas.drawCircle(Offset(px, py), 5,
        Paint()..color = Colors.white..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(px, py), 5,
        Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant _CurvePainter old) =>
    old.points != points || old.color != color;
}
