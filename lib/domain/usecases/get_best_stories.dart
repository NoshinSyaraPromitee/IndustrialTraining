import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetBestStories {
  final StoryRepository repository;
  const GetBestStories(this.repository);

  Future<List<Story>> call() => repository.getBestStories();
}