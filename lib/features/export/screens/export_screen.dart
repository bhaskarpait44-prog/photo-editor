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
  
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  bool _lockAspect = true;

  @override
  void initState() {
    super.initState();
    _widthController.text = widget.image.width.toString();
    _heightController.text = widget.image.height.toString();
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

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
          setState(() => _isExporting = false);
          return;
        }
      }

      ui.Image exportImage = widget.image;

      // Apply resize if needed
      if (_resizeMode == '50%') {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        final newW = (widget.image.width * 0.5).toInt();
        final newH = (widget.image.height * 0.5).toInt();
        canvas.drawImageRect(
          widget.image,
          Rect.fromLTWH(0, 0, widget.image.width.toDouble(), widget.image.height.toDouble()),
          Rect.fromLTWH(0, 0, newW.toDouble(), newH.toDouble()),
          Paint()..filterQuality = FilterQuality.high,
        );
        final picture = recorder.endRecording();
        exportImage = await picture.toImage(newW, newH);
      } else if (_resizeMode == 'Custom') {
        final newW = int.tryParse(_widthController.text) ?? widget.image.width;
        final newH = int.tryParse(_heightController.text) ?? widget.image.height;
        if (newW != widget.image.width || newH != widget.image.height) {
          final recorder = ui.PictureRecorder();
          final canvas = Canvas(recorder);
          canvas.drawImageRect(
            widget.image,
            Rect.fromLTWH(0, 0, widget.image.width.toDouble(), widget.image.height.toDouble()),
            Rect.fromLTWH(0, 0, newW.toDouble(), newH.toDouble()),
            Paint()..filterQuality = FilterQuality.high,
          );
          exportImage = await recorder.endRecording().toImage(newW, newH);
        }
      }

      setState(() => _progress = 0.1);

      final tempDir = await getTemporaryDirectory();
      final filename = 'pixelforge_${DateTime.now().millisecondsSinceEpoch}.$_format';
      final path = '${tempDir.path}/$filename';

      await ExportService.exportImage(
        image: exportImage,
        path: path,
        format: _format,
        quality: _quality,
        onProgress: (p) => setState(() => _progress = 0.1 + p * 0.8),
      );

      setState(() => _progress = 0.95);
      await Gal.putImage(path);
      setState(() => _progress = 1.0);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
              const SizedBox(width: 12),
              Text('Saved as ${_format.toUpperCase()} • ${exportImage.width}×${exportImage.height}px'),
            ]),
            backgroundColor: const Color(0xFF1A1A1A),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting: $e'), backgroundColor: Colors.red),
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
                ButtonSegment(value: 'Custom', label: Text('Custom')),
              ],
              selected: {_resizeMode},
              onSelectionChanged: (set) => setState(() => _resizeMode = set.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.white70),
                backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? const Color(0xFFFF6B35) : Colors.white10),
              ),
            ),
            
            if (_resizeMode == 'Custom') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _widthController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Width (px)',
                        labelStyle: TextStyle(color: Colors.white38),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF6B35))),
                      ),
                      onChanged: (v) {
                        if (_lockAspect) {
                          final w = int.tryParse(v);
                          if (w != null && w > 0) {
                            final ratio = widget.image.height / widget.image.width;
                            _heightController.text = (w * ratio).toInt().toString();
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Height (px)',
                        labelStyle: TextStyle(color: Colors.white38),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF6B35))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(_lockAspect ? Icons.link : Icons.link_off, color: _lockAspect ? const Color(0xFFFF6B35) : Colors.white38),
                    onPressed: () => setState(() => _lockAspect = !_lockAspect),
                  ),
                ],
              ),
            ],
            
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
