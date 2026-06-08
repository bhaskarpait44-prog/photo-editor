import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'models/project_model.dart';
import 'providers/project_provider.dart';
import 'services/shader_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Shaders
  await ShaderService().init();

  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  // Register Adapters
  Hive.registerAdapter(ProjectModelAdapter());

  // Initialize Services
  final container = ProviderContainer();
  await container.read(projectServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PixelForgeApp(),
    ),
  );
}
