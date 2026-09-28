import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/ui/inline_composer.dart';

class AddListColumn extends StatelessWidget {
  const AddListColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final board = context.read<BoardProvider>();
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InlineComposer(
        idleLabel: 'Add another list',
        hint: 'Enter list title',
        submitLabel: 'Add list',
        idleColor: Colors.white,
        trailingIcon: false,
        onSubmit: board.addList,
      ),
    );
  }
}
