import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetNewStories {
  final StoryRepository repository;
  const GetNewStories(this.repository);

  Future<List<Story>> call() => repository.getNewStories();
}