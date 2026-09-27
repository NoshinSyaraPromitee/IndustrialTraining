import '../repositories/comment_repository.dart';

class GetLocalCommentCount {
  final CommentRepository repository;
  const GetLocalCommentCount(this.repository);

  Future<int> call(int storyId) => repository.getLocalCommentCount(storyId);
}