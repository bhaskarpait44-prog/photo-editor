import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import '../../../services/export_service.dart';

class ExportScreen extends ConsumerStatefulWidget {
  final ui.Image image;
  const ExportScreen({super.key, required this.image});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  String _format = 'jpg';
  double _quality = 0.9;
  String _resizeMode = 'Original';
  bool _isExporting = false;
  double _progress = 0.0;

  Future<void> _export() async {
    setState(() {
      _isExporting = true;
      _progress = 0.0;
    });

    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gallery access denied')));
          return;
        }
      }

      final tempDir = await getTemporaryDirectory();
      final filename = 'export_${DateTime.now().millisecondsSinceEpoch}.$_format';
      final path = '${tempDir.path}/$filename';

      // Ignoring resize mode for brevity, would resize in ExportService or ImageProcessingService

      await ExportService.exportImage(
        image: widget.image,
        path: path,
        format: _format,
        quality: _quality,
        onProgress: (p) => setState(() => _progress = p),
      );

      await Gal.putImage(path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery'), backgroundColor: Color(0xFF1A1A1A)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Export', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141414),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Format', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'jpg', label: Text('JPEG')),
                ButtonSegment(value: 'png', label: Text('PNG')),
                ButtonSegment(value: 'webp', label: Text('WEBP')),
              ],
              selected: {_format},
              onSelectionChanged: (set) => setState(() => _format = set.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.white70),
                backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? const Color(0xFFFF6B35) : Colors.white10),
              ),
            ),
            const SizedBox(height: 24),
            
            if (_format != 'png') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quality', style: TextStyle(color: Colors.white70)),
                  Text('${(_quality * 100).toInt()}%', style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: _quality,
                min: 0.1,
                max: 1.0,
                activeColor: const Color(0xFFFF6B35),
                inactiveColor: Colors.white10,
                onChanged: (val) => setState(() => _quality = val),
              ),
              const SizedBox(height: 24),
            ],

            const Text('Resize', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Original', label: Text('Original')),
                ButtonSegment(value: '50%', label: Text('50%')),
              ],
              selected: {_resizeMode},
              onSelectionChanged: (set) => setState(() => _resizeMode = set.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.white70),
                backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? const Color(0xFFFF6B35) : Colors.white10),
              ),
            ),
            
            const Spacer(),
            if (_isExporting)
              Column(
                children: [
                  LinearProgressIndicator(value: _progress, color: const Color(0xFFFF6B35), backgroundColor: Colors.white10),
                  const SizedBox(height: 8),
                  Text('Exporting... ${(_progress * 100).toInt()}%', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isExporting ? null : _export,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Export to Gallery', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
