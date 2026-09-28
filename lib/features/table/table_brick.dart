import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/table/presentation/table_view.dart';

final tableBrick = ViewBrick(
  id: 'table',
  label: 'Table',
  icon: Icons.table_chart_outlined,
  build: (_, close) => TaskTableView(onClose: close),
);
