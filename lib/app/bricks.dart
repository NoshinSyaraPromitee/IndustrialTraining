import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/board/board_brick.dart';
import 'package:taskboard/features/calendar/calendar_brick.dart';
import 'package:taskboard/features/dashboard/dashboard_brick.dart';
import 'package:taskboard/features/inbox/inbox_brick.dart';
import 'package:taskboard/features/map/map_brick.dart';
import 'package:taskboard/features/planner/planner_brick.dart';
import 'package:taskboard/features/projects/projects_brick.dart';
import 'package:taskboard/features/table/table_brick.dart';
import 'package:taskboard/features/timeline/timeline_brick.dart';

/// Dock panels, left to right. Add a PanelBrick here to plug in a new panel.
final panelBricks = <PanelBrick>[
  projectsBrick,
  inboxBrick,
  plannerBrick,
  boardBrick,
];

/// Full-screen views shown in the Views menu. Add a ViewBrick here to plug in a new view.
final viewBricks = <ViewBrick>[
  tableBrick,
  calendarBrick,
  dashboardBrick,
  timelineBrick,
  mapBrick,
];
