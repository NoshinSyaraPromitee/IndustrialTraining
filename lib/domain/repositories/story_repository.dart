import '../entities/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getTopStories();
  Future<List<Story>> getNewStories();
  Future<List<Story>> getBestStories();
}