import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/curves_model.dart';

final curvesProvider = StateNotifierProvider<CurvesNotifier, CurvesState>((ref) {
  return CurvesNotifier();
});

class CurvesNotifier extends StateNotifier<CurvesState> {
  CurvesNotifier() : super(CurvesState.initial());

  void addPoint(String channel, CurvePoint point) {
    final points = _getChannel(channel);
    final newPoints = [...points, point];
    newPoints.sort((a, b) => a.x.compareTo(b.x));
    state = _setChannel(channel, newPoints);
  }

  void movePoint(String channel, int index, CurvePoint newPoint) {
    final points = [..._getChannel(channel)];
    // Clamp x so it doesn't cross neighbors
    double minX = index > 0 ? points[index - 1].x + 0.01 : 0.0;
    double maxX = index < points.length - 1 ? points[index + 1].x - 0.01 : 1.0;
    points[index] = CurvePoint(newPoint.x.clamp(minX, maxX), newPoint.y.clamp(0.0, 1.0));
    state = _setChannel(channel, points);
  }

  void removePoint(String channel, int index) {
    final points = [..._getChannel(channel)];
    // Don't remove first or last point
    if (index == 0 || index == points.length - 1) return;
    points.removeAt(index);
    state = _setChannel(channel, points);
  }

  void resetChannel(String channel) {
    state = _setChannel(channel, [CurvePoint(0, 0), CurvePoint(1, 1)]);
  }

  void resetAll() {
    state = CurvesState.initial();
  }

  List<CurvePoint> _getChannel(String channel) {
    switch (channel) {
      case 'r': return state.red;
      case 'g': return state.green;
      case 'b': return state.blue;
      default: return state.rgb;
    }
  }

  CurvesState _setChannel(String channel, List<CurvePoint> points) {
    switch (channel) {
      case 'r': return CurvesState(rgb: state.rgb, red: points, green: state.green, blue: state.blue);
      case 'g': return CurvesState(rgb: state.rgb, red: state.red, green: points, blue: state.blue);
      case 'b': return CurvesState(rgb: state.rgb, red: state.red, green: state.green, blue: points);
      default: return CurvesState(rgb: points, red: state.red, green: state.green, blue: state.blue);
    }
  }

  // Generate 256-entry LUT from curve points using linear interpolation
  static List<double> generateLUT(List<CurvePoint> points) {
    final lut = List<double>.filled(256, 0.0);
    for (int i = 0; i < 256; i++) {
      final x = i / 255.0;
      // Find the two surrounding points
      int lo = 0;
      for (int j = 0; j < points.length - 1; j++) {
        if (points[j].x <= x) lo = j;
      }
      final hi = (lo + 1).clamp(0, points.length - 1);
      if (lo == hi) {
        lut[i] = points[lo].y;
      } else {
        final t = (x - points[lo].x) / (points[hi].x - points[lo].x);
        lut[i] = (points[lo].y + t * (points[hi].y - points[lo].y)).clamp(0.0, 1.0);
      }
    }
    return lut;
  }
}
