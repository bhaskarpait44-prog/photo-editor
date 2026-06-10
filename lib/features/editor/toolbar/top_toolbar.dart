import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../providers/editor_provider.dart';
import '../../../providers/adjustments_provider.dart';

class TopToolbar extends ConsumerWidget {
  final VoidCallback onSave;
  final VoidCallback onExport;

  const TopToolbar({
    super.key,
    required this.onSave,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorProvider);
    final notifier = ref.read(editorProvider.notifier);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              PhosphorIcons.caretLeft,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              PhosphorIcons.arrowCounterClockwise,
              color: notifier.canUndo ? Colors.white : Colors.white38,
            ),
            onPressed: notifier.canUndo 
                ? () => notifier.undo((adj) => ref.read(adjustmentsProvider.notifier).state = adj) 
                : null,
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.arrowClockwise,
              color: notifier.canRedo ? Colors.white : Colors.white38,
            ),
            onPressed: notifier.canRedo 
                ? () => notifier.redo((adj) => ref.read(adjustmentsProvider.notifier).state = adj) 
                : null,
          ),
          const SizedBox(width: 8),
          _ToolButton(
            icon: PhosphorIcons.rows,
            isSelected: editorState.isBeforeView,
            onPressed: () => notifier.setBeforeView(!editorState.isBeforeView),
          ),
          Consumer(
            builder: (context, ref, _) {
              final isVisible = ref.watch(isHistogramVisibleProvider);
              return IconButton(
                icon: Icon(Icons.bar_chart, color: isVisible ? const Color(0xFFFF6B35) : Colors.white),
                onPressed: () => ref.read(isHistogramVisibleProvider.notifier).state = !isVisible,
              );
            },
          ),
          const Spacer(),
          TextButton(
            onPressed: onSave,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onExport,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ToolButton({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
