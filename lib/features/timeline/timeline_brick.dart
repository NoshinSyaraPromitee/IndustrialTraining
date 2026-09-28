import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/timeline/presentation/timeline_view.dart';

final timelineBrick = ViewBrick(
  id: 'timeline',
  label: 'Timeline',
  icon: Icons.view_timeline_outlined,
  build: (_, close) => TaskTimelineView(onClose: close),
);
