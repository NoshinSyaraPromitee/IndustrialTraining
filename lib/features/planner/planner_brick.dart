import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/planner/presentation/planner_panel.dart';

final plannerBrick = PanelBrick(
  id: 'planner',
  label: 'Planner',
  icon: Icons.calendar_today_outlined,
  flex: 4,
  build: (_) => const PlannerPanel(),
);
