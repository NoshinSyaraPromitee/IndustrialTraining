import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/comment.dart';
import '../../domain/entities/story.dart';
import '../models/story_do.dart';
import '../models/comment_do.dart';

abstract class HackerNewsRemoteDataSource {
  Future<List<Story>> getTopStories();
  Future<List<Story>> getNewStories();
  Future<List<Story>> getBestStories();
  Future<List<Comment>> getStoryComments(List<int> kidIds);
}

class HackerNewsRemoteDataSourceImpl implements HackerNewsRemoteDataSource {
  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';
  final http.Client client;

  HackerNewsRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<Story>> getTopStories() => _getStories('/topstories.json');

  @override
  Future<List<Story>> getNewStories() => _getStories('/newstories.json');

  @override
  Future<List<Story>> getBestStories() => _getStories('/beststories.json');

  Future<List<Story>> _getStories(String endpoint) async {
    final response = await client.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load stories');
    }

    final List<dynamic> ids = jsonDecode(response.body);
    final limitedIds = ids.take(20).toList();

    final stories = await Future.wait(
      limitedIds.map((id) => _getStory(id)),
    );

    return stories.whereType<Story>().toList();
  }

  Future<Story?> _getStory(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/item/$id.json'));
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data == null || data['type'] != 'story') return null;

    return StoryDO.fromJson(data).toEntity();
  }

  @override
  Future<List<Comment>> getStoryComments(List<int> kidIds) async {
    final results = await Future.wait(kidIds.map((id) => _getCommentTree(id)));
    return results.whereType<Comment>().toList();
  }

  /// Recursively fetches an HN item and all of its descendants.
  /// Every level is fetched in parallel via Future.wait, so a deep thread
  /// costs roughly `depth` round-trips rather than one per comment.
  Future<Comment?> _getCommentTree(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/item/$id.json'));
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data == null) return null;

    final dto = CommentDO.fromJson(data);
    final replies = await Future.wait(
      (dto.kids ?? const <int>[]).map((kidId) => _getCommentTree(kidId)),
    );

    return dto.toEntity(replies.whereType<Comment>().toList());
  }
}