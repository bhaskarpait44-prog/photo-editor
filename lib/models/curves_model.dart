class CurvePoint {
  final double x; // 0 to 1
  final double y; // 0 to 1

  CurvePoint(this.x, this.y);
}

class CurvesState {
  final List<CurvePoint> rgb;
  final List<CurvePoint> red;
  final List<CurvePoint> green;
  final List<CurvePoint> blue;

  CurvesState({
    required this.rgb,
    required this.red,
    required this.green,
    required this.blue,
  });

  factory CurvesState.initial() {
    return CurvesState(
      rgb: [CurvePoint(0, 0), CurvePoint(1, 1)],
      red: [CurvePoint(0, 0), CurvePoint(1, 1)],
      green: [CurvePoint(0, 0), CurvePoint(1, 1)],
      blue: [CurvePoint(0, 0), CurvePoint(1, 1)],
    );
  }
}
