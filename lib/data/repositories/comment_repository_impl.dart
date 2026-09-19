import '../../domain/entities/comment.dart';
import '../../domain/entities/local_comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/hacker_news_remote_data_source.dart';
import '../datasources/comment_local_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  final HackerNewsRemoteDataSource remoteDataSource;
  final CommentLocalDataSource localDataSource;

  const CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Comment>> getStoryComments(List<int> kidIds) =>
      remoteDataSource.getStoryComments(kidIds);

  @override
  Future<List<LocalComment>> getLocalComments(int storyId) =>
      localDataSource.getComments(storyId);

  @override
  Future<int> getLocalCommentCount(int storyId) async {
    final comments = await localDataSource.getComments(storyId);
    return comments.length;
  }

  @override
  Future<void> addLocalComment(int storyId, String text, {int? parentId}) =>
      localDataSource.addComment(storyId, text, parentId: parentId);
}