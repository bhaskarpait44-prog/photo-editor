import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../providers/editor_provider.dart';

class BottomToolbar extends ConsumerWidget {
  const BottomToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTool = ref.watch(editorProvider.select((s) => s.activeTool));
    final notifier = ref.read(editorProvider.notifier);

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ToolIcon(
            icon: PhosphorIcons.slidersHorizontal,
            label: 'Adjust',
            isSelected: activeTool == EditorTool.adjust,
            onTap: () => notifier.setActiveTool(EditorTool.adjust),
          ),
          _ToolIcon(
            icon: PhosphorIcons.magicWand,
            label: 'Filters',
            isSelected: activeTool == EditorTool.filter,
            onTap: () => notifier.setActiveTool(EditorTool.filter),
          ),
          _ToolIcon(
            icon: PhosphorIcons.crop,
            label: 'Crop',
            isSelected: activeTool == EditorTool.crop,
            onTap: () => notifier.setActiveTool(EditorTool.crop),
          ),
          _ToolIcon(
            icon: PhosphorIcons.stack,
            label: 'Layers',
            isSelected: activeTool == EditorTool.layers,
            onTap: () => notifier.setActiveTool(EditorTool.layers),
          ),
          _ToolIcon(
            icon: PhosphorIcons.paintBrush,
            label: 'Brush',
            isSelected: activeTool == EditorTool.brush,
            onTap: () => notifier.setActiveTool(EditorTool.brush),
          ),
          _ToolIcon(
            icon: PhosphorIcons.textT,
            label: 'Text',
            isSelected: activeTool == EditorTool.text,
            onTap: () => notifier.setActiveTool(EditorTool.text),
          ),
          _ToolIcon(
            icon: PhosphorIcons.bandaids,
            label: 'Heal',
            isSelected: activeTool == EditorTool.heal,
            onTap: () => notifier.setActiveTool(EditorTool.heal),
          ),
          _ToolIcon(
            icon: PhosphorIcons.arrowsOut,
            label: 'Transform',
            isSelected: activeTool == EditorTool.transform,
            onTap: () => notifier.setActiveTool(EditorTool.transform),
          ),
        ],
      ),
    );
  }
}

class _ToolIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolIcon({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFFFF6B35) : Colors.white;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
