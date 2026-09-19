import 'package:http/http.dart' as http;
import '../../data/datasources/hacker_news_remote_data_source.dart';
import '../../data/datasources/comment_local_data_source.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/repositories/comment_repository.dart';
import '../../domain/usecases/get_top_stories.dart';
import '../../domain/usecases/get_new_stories.dart';
import '../../domain/usecases/get_best_stories.dart';
import '../../domain/usecases/get_story_comments.dart';
import '../../domain/usecases/get_local_comments.dart';
import '../../domain/usecases/get_local_comment_count.dart';
import '../../domain/usecases/add_local_comment.dart';

/// Simple manual service locator — wires data sources, repositories and
/// use cases together in one place. Swap for get_it later if you want
/// lazier/scoped instances; the rest of the app only ever talks to
/// use cases, so nothing else would need to change.
class Injector {
  Injector._();

  static final http.Client _httpClient = http.Client();

  static final HackerNewsRemoteDataSource _hackerNewsRemoteDataSource =
      HackerNewsRemoteDataSourceImpl(client: _httpClient);

  static final CommentLocalDataSource _commentLocalDataSource =
      CommentLocalDataSourceImpl();

  static final StoryRepository _storyRepository =
      StoryRepositoryImpl(_hackerNewsRemoteDataSource);

  static final CommentRepository _commentRepository = CommentRepositoryImpl(
    remoteDataSource: _hackerNewsRemoteDataSource,
    localDataSource: _commentLocalDataSource,
  );

  static final GetTopStories getTopStories = GetTopStories(_storyRepository);
  static final GetNewStories getNewStories = GetNewStories(_storyRepository);
  static final GetBestStories getBestStories = GetBestStories(_storyRepository);

  static final GetStoryComments getStoryComments =
      GetStoryComments(_commentRepository);
  static final GetLocalComments getLocalComments =
      GetLocalComments(_commentRepository);
  static final GetLocalCommentCount getLocalCommentCount =
      GetLocalCommentCount(_commentRepository);
  static final AddLocalComment addLocalComment =
      AddLocalComment(_commentRepository);
}