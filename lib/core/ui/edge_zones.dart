import 'package:flutter/material.dart';

/// Invisible strips at the screen edges. Holding a dragged card over one
/// scrolls the board sideways.
class EdgeZones extends StatefulWidget {
  const EdgeZones({super.key, required this.controller});
  final ScrollController controller;

  @override
  State<EdgeZones> createState() => _EdgeZonesState();
}

class _EdgeZonesState extends State<EdgeZones> {
  bool _busy = false;

  Future<void> _go(int delta) async {
    final c = widget.controller;
    if (_busy || !c.hasClients) return;
    _busy = true;
    final pos = c.position;
    final target = (pos.pixels + delta * 310).clamp(
      pos.minScrollExtent,
      pos.maxScrollExtent,
    );
    await c.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    await Future.delayed(const Duration(milliseconds: 100));
    _busy = false;
  }

  Widget _zone(int delta) => SizedBox(
    width: 36,
    child: DragTarget<String>(
      onWillAcceptWithDetails: (_) => true,
      onMove: (_) => _go(delta),
      builder: (_, _, _) => const SizedBox.expand(),
    ),
  );

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: Row(children: [_zone(-1), const Spacer(), _zone(1)]),
  );
}
