import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/selection_provider.dart';
import '../tools/selection_tool_overlay.dart';

class SelectionPanel extends ConsumerWidget {
  const SelectionPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(selectionToolModeProvider);
    final hasSelection = ref.watch(selectionProvider).selectionPath != null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Selection Tool', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        
        // Tool mode selector
        Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: 'Rectangle',
                icon: Icons.crop_square,
                isSelected: mode == SelectionToolMode.rectangle,
                onTap: () => ref.read(selectionToolModeProvider.notifier).state = SelectionToolMode.rectangle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ModeButton(
                label: 'Lasso',
                icon: Icons.gesture,
                isSelected: mode == SelectionToolMode.lasso,
                onTap: () => ref.read(selectionToolModeProvider.notifier).state = SelectionToolMode.lasso,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Selection operations
        if (hasSelection) ...[
          const Text('Operations', style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          _OperationButton(
            label: 'Invert Selection',
            icon: Icons.invert_colors,
            onTap: () {
              // Invert: create rect of full canvas, subtract current selection
              final current = ref.read(selectionProvider).selectionPath;
              if (current == null) return;
              final full = Path()..addRect(const Rect.fromLTWH(0, 0, 10000, 10000));
              final inverted = Path.combine(PathOperation.difference, full, current);
              ref.read(selectionProvider.notifier).setPath(inverted);
            },
          ),
          const SizedBox(height: 8),
          _OperationButton(
            label: 'Clear Selection',
            icon: Icons.clear,
            onTap: () => ref.read(selectionProvider.notifier).clear(),
            isDestructive: true,
          ),
        ] else ...[
          const Center(
            child: Text(
              'Draw on canvas to create a selection',
              style: TextStyle(color: Colors.white38, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF6B35).withValues(alpha: 0.2) : Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent),
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFFF6B35) : Colors.white70, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFFFF6B35) : Colors.white70, fontSize: 11)),
        ],
      ),
    ),
  );
}

class _OperationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const _OperationButton({required this.label, required this.icon, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.redAccent : Colors.white70, size: 18),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white70)),
        ],
      ),
    ),
  );
}
