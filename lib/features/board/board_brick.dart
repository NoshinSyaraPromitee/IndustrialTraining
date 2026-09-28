import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/board/presentation/board_panel.dart';

final boardBrick = PanelBrick(
  id: 'board',
  label: 'Board',
  icon: Icons.view_column_outlined,
  flex: 8,
  build: (_) => const BoardPanel(),
);
