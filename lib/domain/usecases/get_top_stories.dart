import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetTopStories {
  final StoryRepository repository;
  const GetTopStories(this.repository);

  Future<List<Story>> call() => repository.getTopStories();
}