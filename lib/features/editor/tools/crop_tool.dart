import 'package:flutter/material.dart';

class CropTool extends StatefulWidget {
  final Size imageSize;
  final Function(Rect) onCropApplied;
  final VoidCallback onCancel;

  const CropTool({
    super.key,
    required this.imageSize,
    required this.onCropApplied,
    required this.onCancel,
  });

  @override
  State<CropTool> createState() => _CropToolState();
}

class _CropToolState extends State<CropTool> {
  late Rect _cropRect;
  
  @override
  void initState() {
    super.initState();
    _cropRect = Rect.fromLTWH(0, 0, widget.imageSize.width, widget.imageSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Darkened area outside crop
        // Rule of thirds grid
        // Draggable handles
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: widget.onCancel,
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => widget.onCropApplied(_cropRect),
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
