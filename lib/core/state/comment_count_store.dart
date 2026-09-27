import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_local_comment_count.dart';

/// Single source of truth for how many *locally added* comments each story
/// has, shared by every widget that displays a count (story list cards,
/// the detail screen). Adding a comment anywhere calls [increment], which
/// notifies all listeners in the same frame — this is what makes the
/// comment count actual global state, not state private to one screen.
class CommentCountStore extends ChangeNotifier {
  CommentCountStore(this._getLocalCommentCount);

  final GetLocalCommentCount _getLocalCommentCount;

  final Map<int, int> _counts = {};

  /// Locally added comment count for [storyId]. 0 until [ensureLoaded]
  /// (or [reload]) has resolved at least once for that story.
  int countFor(int storyId) => _counts[storyId] ?? 0;

  /// Loads the persisted count for [storyId] the first time it's needed.
  /// Safe to call on every build/initState — it only hits storage once
  /// per story, subsequent calls are a no-op.
  Future<void> ensureLoaded(int storyId) async {
    if (_counts.containsKey(storyId)) return;
    await reload(storyId);
  }

  /// Re-reads the persisted count from storage and notifies listeners.
  Future<void> reload(int storyId) async {
    final count = await _getLocalCommentCount(storyId);
    _counts[storyId] = count;
    notifyListeners();
  }

  /// Call immediately after a comment is successfully persisted, so every
  /// listener (list cards on every tab, the detail screen) updates without
  /// waiting on a storage round trip or a navigation pop.
  void increment(int storyId) {
    _counts[storyId] = countFor(storyId) + 1;
    notifyListeners();
  }
}