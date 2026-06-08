import 'dart:typed_data';
import 'dart:ui' as ui;

class HistogramData {
  final Uint32List red;
  final Uint32List green;
  final Uint32List blue;
  final Uint32List luminance;

  HistogramData({
    required this.red,
    required this.green,
    required this.blue,
    required this.luminance,
  });
}

class HistogramService {
  static Future<HistogramData> computeHistogram(ui.Image image) async {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bytes == null) return _empty();

    final data = bytes.buffer.asUint8List();
    final r = Uint32List(256);
    final g = Uint32List(256);
    final b = Uint32List(256);
    final l = Uint32List(256);

    for (int i = 0; i < data.length; i += 4) {
      final red = data[i];
      final green = data[i + 1];
      final blue = data[i + 2];
      
      r[red]++;
      g[green]++;
      b[blue]++;
      
      final luma = (0.299 * red + 0.587 * green + 0.114 * blue).round();
      l[luma]++;
    }

    return HistogramData(red: r, green: g, blue: b, luminance: l);
  }

  static HistogramData _empty() {
    return HistogramData(
      red: Uint32List(256),
      green: Uint32List(256),
      blue: Uint32List(256),
      luminance: Uint32List(256),
    );
  }
}
