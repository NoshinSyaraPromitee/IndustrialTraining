import '../repositories/comment_repository.dart';

class AddLocalComment {
  final CommentRepository repository;
  const AddLocalComment(this.repository);

  Future<void> call(int storyId, String text, {int? parentId}) =>
      repository.addLocalComment(storyId, text, parentId: parentId);
}