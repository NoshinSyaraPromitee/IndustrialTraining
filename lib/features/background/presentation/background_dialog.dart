import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/background/presentation/background_provider.dart';
import 'package:taskboard/features/background/domain/backgrounds.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/features/background/presentation/bg_swatches.dart';

Future<void> showBackgroundDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => const _BackgroundDialog(),
);

class _BackgroundDialog extends StatelessWidget {
  const _BackgroundDialog();

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Trello.subtle,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bg = context.watch<BackgroundProvider>();
    return Dialog(
      backgroundColor: Trello.card,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Board background',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Trello.text,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Trello.subtle,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _label('Color'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var i = 0; i < bgPresets.length; i++)
                    Swatch(
                      preset: bgPresets[i],
                      selected: bg.gradient == i,
                      onTap: () => bg.setGradient(i),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              _label('Pattern'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final p in BgPattern.values)
                    PatternTile(
                      pattern: p,
                      preset: bgPresets[bg.gradient],
                      selected: bg.pattern == p,
                      onTap: () => bg.setPattern(p),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
