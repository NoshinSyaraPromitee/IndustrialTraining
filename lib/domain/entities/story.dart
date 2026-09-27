/// Pure domain entity — no JSON, no Flutter, no storage details.
class Story {
  final int id;
  final String title;
  final String author;
  final String? url;
  final int score;
  final int time;
  final int commentCount;
  final List<int> kids; // top-level comment ids, used to fetch the thread

  const Story({
    required this.id,
    required this.title,
    required this.author,
    this.url,
    required this.score,
    required this.time,
    required this.commentCount,
    this.kids = const [],
  });
}