import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/hacker_news_remote_data_source.dart';

class StoryRepositoryImpl implements StoryRepository {
  final HackerNewsRemoteDataSource remoteDataSource;
  const StoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Story>> getTopStories() => remoteDataSource.getTopStories();

  @override
  Future<List<Story>> getNewStories() => remoteDataSource.getNewStories();

  @override
  Future<List<Story>> getBestStories() => remoteDataSource.getBestStories();
}