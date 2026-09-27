import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class GetStoryComments {
  final CommentRepository repository;
  const GetStoryComments(this.repository);

  Future<List<Comment>> call(List<int> kidIds) =>
      repository.getStoryComments(kidIds);
}