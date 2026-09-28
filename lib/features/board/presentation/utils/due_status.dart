import 'package:flutter/material.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';

enum DueStatus { complete, soon, later, overdue, none }

extension DueStatusX on DueStatus {
  String get label => switch (this) {
    DueStatus.complete => 'Complete',
    DueStatus.soon => 'Due soon',
    DueStatus.later => 'Due later',
    DueStatus.overdue => 'Overdue',
    DueStatus.none => 'No due date',
  };

  Color get color => switch (this) {
    DueStatus.complete => Trello.green,
    DueStatus.soon => const Color(0xFFF5CD47),
    DueStatus.later => Trello.accent,
    DueStatus.overdue => const Color(0xFFF87168),
    DueStatus.none => const Color(0xFF8590A2),
  };
}

DueStatus dueStatusOf(TaskCard c) {
  if (c.done) return DueStatus.complete;
  final d = c.due;
  if (d == null) return DueStatus.none;
  final today = dateOnly(DateTime.now());
  final day = dateOnly(d);
  if (day.isBefore(today)) return DueStatus.overdue;
  if (daysBetween(today, day) <= 1) return DueStatus.soon;
  return DueStatus.later;
}

/// Whole days from [a] to [b] (DST-safe).
int daysBetween(DateTime a, DateTime b) => DateTime.utc(
  b.year,
  b.month,
  b.day,
).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
