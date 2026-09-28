import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/calendar/presentation/calendar_view.dart';

final calendarBrick = ViewBrick(
  id: 'calendar',
  label: 'Calendar',
  icon: Icons.calendar_month_outlined,
  build: (_, close) => TaskCalendarView(onClose: close),
);
