import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/dashboard/presentation/dashboard_view.dart';

final dashboardBrick = ViewBrick(
  id: 'dashboard',
  label: 'Dashboard',
  icon: Icons.speed_outlined,
  build: (_, close) => TaskDashboardView(onClose: close),
);
