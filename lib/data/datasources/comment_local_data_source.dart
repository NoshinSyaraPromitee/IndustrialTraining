import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/local_comment.dart';
import '../models/local_comment_do.dart';

abstract class CommentLocalDataSource {
  Future<List<LocalComment>> getComments(int storyId);
  Future<void> addComment(int storyId, String text, {int? parentId});
}

class CommentLocalDataSourceImpl implements CommentLocalDataSource {
  static const String _key = 'story_comments_v2';

  Future<Map<String, List<LocalCommentDO>>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return {};

    final decoded = jsonDecode(data) as Map<String, dynamic>;

    return decoded.map(
      (storyId, list) => MapEntry(
        storyId,
        (list as List)
            .map((e) => LocalCommentDO.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  Future<void> _saveAll(Map<String, List<LocalCommentDO>> all) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = all.map(
      (storyId, list) => MapEntry(
        storyId,
        list.map((c) => c.toJson()).toList(),
      ),
    );
    await prefs.setString(_key, jsonEncode(encoded));
  }

  @override
  Future<List<LocalComment>> getComments(int storyId) async {
    final all = await _loadAll();
    final list = all[storyId.toString()] ?? [];
    return list.map((c) => c.toEntity()).toList();
  }

  @override
  Future<void> addComment(int storyId, String text, {int? parentId}) async {
    final all = await _loadAll();
    final storyKey = storyId.toString();
    final comments = all.putIfAbsent(storyKey, () => []);

    comments.add(LocalCommentDO(
      id: DateTime.now().microsecondsSinceEpoch,
      parentId: parentId,
      text: text,
      time: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    ));

    await _saveAll(all);
  }
}