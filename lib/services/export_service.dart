import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class ExportService {
  static Future<void> exportImage({
    required ui.Image image,
    required String path,
    required String format,
    double quality = 0.9,
  }) async {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return;

    final decoded = img.decodeImage(bytes.buffer.asUint8List());
    if (decoded == null) return;

    Uint8List encoded;
    if (format == 'jpg') {
      encoded = Uint8List.fromList(img.encodeJpg(decoded, quality: (quality * 100).toInt()));
    } else {
      encoded = Uint8List.fromList(img.encodePng(decoded));
    }

    await File(path).writeAsBytes(encoded);
  }
}
