import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';

/// "+ Add a card" row that expands into an inline text field.
class InlineComposer extends StatefulWidget {
  const InlineComposer({
    super.key,
    required this.idleLabel,
    required this.hint,
    required this.submitLabel,
    required this.onSubmit,
    this.idleColor = Trello.subtle,
    this.trailingIcon = true,
  });
  final String idleLabel, hint, submitLabel;
  final ValueChanged<String> onSubmit;
  final Color idleColor;
  final bool trailingIcon;

  @override
  State<InlineComposer> createState() => _InlineComposerState();
}

class _InlineComposerState extends State<InlineComposer> {
  final _c = TextEditingController();
  bool _open = false;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    final t = _c.text.trim();
    if (t.isNotEmpty) widget.onSubmit(t);
    _c.clear();
  }

  void _close() {
    _c.clear();
    setState(() => _open = false);
  }

  Widget _idle() => Row(
    children: [
      Expanded(
        child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: widget.idleColor,
            alignment: Alignment.centerLeft,
            minimumSize: const Size.fromHeight(40),
          ),
          icon: const Icon(Icons.add),
          label: Text(widget.idleLabel),
          onPressed: () => setState(() => _open = true),
        ),
      ),
      if (widget.trailingIcon)
        Icon(Icons.post_add_outlined, size: 20, color: widget.idleColor),
      if (widget.trailingIcon) const SizedBox(width: 8),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (!_open) return _idle();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 1,
          color: Trello.card,
          borderRadius: BorderRadius.circular(8),
          child: TextField(
            controller: _c,
            autofocus: true,
            style: const TextStyle(color: Trello.text),
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Trello.subtle),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Trello.accent,
                foregroundColor: Trello.onAccent,
              ),
              onPressed: _submit,
              child: Text(widget.submitLabel),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: widget.idleColor,
              onPressed: _close,
            ),
          ],
        ),
      ],
    );
  }
}
