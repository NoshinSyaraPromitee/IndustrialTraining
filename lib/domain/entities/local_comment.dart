/// A comment the user added locally (stored on-device, not sent to HN).
class LocalComment {
  final int id;
  final int? parentId;
  final String text;
  final int time;

  const LocalComment({
    required this.id,
    this.parentId,
    required this.text,
    required this.time,
  });
}