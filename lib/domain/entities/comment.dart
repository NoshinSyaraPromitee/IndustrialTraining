/// A real Hacker News comment, already resolved into a tree of replies.
class Comment {
  final int id;
  final String? author;
  final String text;
  final int time;
  final bool deleted;
  final List<Comment> replies;

  const Comment({
    required this.id,
    this.author,
    required this.text,
    required this.time,
    this.deleted = false,
    this.replies = const [],
  });
}