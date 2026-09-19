import '../entities/local_comment.dart';
import '../repositories/comment_repository.dart';

class GetLocalComments {
  final CommentRepository repository;
  const GetLocalComments(this.repository);

  Future<List<LocalComment>> call(int storyId) =>
      repository.getLocalComments(storyId);
}