import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/features/board/presentation/widgets/card_sheet.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/core/ui/view_close_button.dart';

class TaskMapView extends StatefulWidget {
  const TaskMapView({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  State<TaskMapView> createState() => _TaskMapViewState();
}

class _TaskMapViewState extends State<TaskMapView> {
  String? _sel;

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final cards = board.allCards;
    final placed = [
      for (final e in cards)
        if (e.$1.hasLocation) e.$1,
    ];
    final sel = cards
        .where((e) => e.$1.id == _sel)
        .map((e) => e.$1)
        .firstOrNull;
    final center = placed.isNotEmpty
        ? LatLng(placed.first.lat!, placed.first.lng!)
        : const LatLng(20, 0);

    final hint = sel == null
        ? 'Select a card, then tap the map to pin it.'
        : sel.hasLocation
        ? 'Tap the map to move the pin for "${sel.title}".'
        : 'Tap the map to place "${sel.title}".';

    return PanelShell(
      icon: Icons.place_outlined,
      title: 'Map',
      trailing: ViewCloseButton(onPressed: widget.onClose),
      child: cards.isEmpty
          ? const Center(
              child: Text(
                'Create some cards on the Board first',
                style: TextStyle(color: Trello.subtle),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 46,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      for (final e in cards)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8,
                            top: 4,
                            bottom: 4,
                          ),
                          child: ChoiceChip(
                            avatar: Icon(
                              e.$1.hasLocation
                                  ? Icons.location_on
                                  : Icons.location_off_outlined,
                              size: 16,
                            ),
                            label: Text(e.$1.title),
                            selected: _sel == e.$1.id,
                            onSelected: (on) =>
                                setState(() => _sel = on ? e.$1.id : null),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          hint,
                          style: const TextStyle(
                            color: Trello.subtle,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (sel != null && sel.hasLocation)
                        TextButton(
                          onPressed: () => board.locateCard(sel.id, null, null),
                          child: const Text('Remove pin'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: center,
                          initialZoom: placed.isNotEmpty ? 5 : 2,
                          onTap: (_, point) {
                            final id = _sel;
                            if (id != null) {
                              context.read<BoardProvider>().locateCard(
                                id,
                                point.latitude,
                                point.longitude,
                              );
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.taskboard',
                          ),
                          MarkerLayer(
                            markers: [
                              for (final c in placed)
                                Marker(
                                  point: LatLng(c.lat!, c.lng!),
                                  width: 44,
                                  height: 44,
                                  alignment: Alignment.topCenter,
                                  child: GestureDetector(
                                    onTap: () => showCardSheet(context, c),
                                    child: Tooltip(
                                      message: c.title,
                                      child: Icon(
                                        Icons.location_on,
                                        size: c.id == _sel ? 44 : 36,
                                        color: c.id == _sel
                                            ? Trello.accent
                                            : (c.done
                                                  ? Trello.green
                                                  : const Color(0xFFF87168)),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          color: Colors.white70,
                          child: const Text(
                            '© OpenStreetMap contributors',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
