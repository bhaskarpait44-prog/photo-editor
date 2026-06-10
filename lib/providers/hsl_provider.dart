import 'package:flutter_riverpod/flutter_riverpod.dart';

class HslRangeState {
  final List<double> hueOffsets;
  final List<double> satOffsets;
  final List<double> lumOffsets;

  static const List<String> rangeNames = ['Red','Orange','Yellow','Green','Aqua','Blue','Purple','Magenta'];
  static const List<int> rangeColors = [0xFFFF3333, 0xFFFF8800, 0xFFFFEE00, 0xFF33CC33, 0xFF00CCCC, 0xFF3366FF, 0xFF8833FF, 0xFFFF33CC];

  HslRangeState({
    List<double>? hueOffsets,
    List<double>? satOffsets,
    List<double>? lumOffsets,
  })  : hueOffsets = hueOffsets ?? List.filled(8, 0.0),
        satOffsets = satOffsets ?? List.filled(8, 0.0),
        lumOffsets = lumOffsets ?? List.filled(8, 0.0);

  HslRangeState copyWithHue(int i, double v) { final l = [...hueOffsets]; l[i] = v; return HslRangeState(hueOffsets: l, satOffsets: satOffsets, lumOffsets: lumOffsets); }
  HslRangeState copyWithSat(int i, double v) { final l = [...satOffsets]; l[i] = v; return HslRangeState(hueOffsets: hueOffsets, satOffsets: l, lumOffsets: lumOffsets); }
  HslRangeState copyWithLum(int i, double v) { final l = [...lumOffsets]; l[i] = v; return HslRangeState(hueOffsets: hueOffsets, satOffsets: satOffsets, lumOffsets: l); }
  HslRangeState reset() => HslRangeState();
}

final hslProvider = StateProvider<HslRangeState>((ref) => HslRangeState());
final selectedHslRangeProvider = StateProvider<int>((ref) => 0);
