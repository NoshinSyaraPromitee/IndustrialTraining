const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String shortDate(DateTime d) =>
    '${months[d.month - 1].substring(0, 3)} ${d.day}';

String dayLabel(DateTime d) => '${weekdays[d.weekday - 1]}, ${shortDate(d)}';

/// Planner heading: ("Today", "Mon September 28"), ("Wed", "September 30").
(String, String) dayParts(DateTime d) {
  final t = dateOnly(DateTime.now());
  final tomorrow = DateTime(t.year, t.month, t.day + 1);
  final date = '${months[d.month - 1]} ${d.day}';
  final wd = weekdays[d.weekday - 1];
  if (sameDay(d, t)) return ('Today', '$wd $date');
  if (sameDay(d, tomorrow)) return ('Tomorrow', '$wd $date');
  return (wd, date);
}
