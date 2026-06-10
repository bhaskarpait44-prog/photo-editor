import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/histogram_service.dart';
import 'editor_provider.dart';

final histogramProvider = FutureProvider<HistogramData?>((ref) async {
  final image = ref.watch(editorProvider).image;
  if (image == null) return null;
  return HistogramService.computeHistogram(image);
});
