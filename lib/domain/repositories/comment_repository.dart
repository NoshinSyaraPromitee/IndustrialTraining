import '../entities/comment.dart';
import '../entities/local_comment.dart';

abstract class CommentRepository {
  /// Fetches the full HN comment tree for the given top-level comment ids.
  Future<List<Comment>> getStoryComments(List<int> kidIds);

  Future<List<LocalComment>> getLocalComments(int storyId);
  Future<int> getLocalCommentCount(int storyId);
  Future<void> addLocalComment(int storyId, String text, {int? parentId});
}