import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/adjustment_model.dart';

final adjustmentsProvider = StateProvider<AdjustmentModel>((ref) => const AdjustmentModel());
