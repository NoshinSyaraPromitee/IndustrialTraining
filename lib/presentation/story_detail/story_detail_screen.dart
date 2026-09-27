import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/di/injector.dart';
import '../../core/utils/time_formatter.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/story.dart';
import 'widgets/comment_list.dart';
import 'widgets/comment_input.dart';
import 'widgets/hn_comment_tile.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;
  final int imageIndex;

  const StoryDetailScreen({
    super.key,
    required this.story,
    required this.imageIndex,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final commentListKey = GlobalKey<CommentListState>();
  late Future<List<Comment>> hnComments;

  @override
  void initState() {
    super.initState();
    Injector.commentCountStore.ensureLoaded(widget.story.id);
    hnComments = Injector.getStoryComments(widget.story.kids);
  }

  void _reloadComments() {
    setState(() => hnComments = Injector.getStoryComments(widget.story.kids));
  }

  Future<void> _openArticle(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the article link.')),
      );
    }
  }

  String get imagePath {
    final number = (widget.imageIndex % 5) + 1;
    return 'assets/images/tech$number.png';
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;

    return Scaffold(
      appBar: AppBar(title: const Text('Story')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, width: double.infinity, height: 220, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('by ${story.author}'),
                  const SizedBox(height: 6),
                  Text('${story.score} points • ${TimeFormatter.timeAgo(story.time)}'),
                  if (story.url != null) ...[
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _openArticle(story.url!),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.open_in_new, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              story.url!,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ListenableBuilder(
                    listenable: Injector.commentCountStore,
                    builder: (context, _) {
                      final local = Injector.commentCountStore.countFor(story.id);
                      final total = story.commentCount + local;
                      return Text(
                        '$total comments${local > 0 ? ' ($local added locally)' : ''}',
                      );
                    },
                  ),
                  const Divider(height: 24),

                  const Text('Discussion', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Comment>>(
                    future: hnComments,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Failed to load comments.'),
                            TextButton(
                              onPressed: _reloadComments,
                              child: const Text('Retry'),
                            ),
                          ],
                        );
                      }
                      final comments = snapshot.data ?? [];
                      if (comments.isEmpty) {
                        return const Text('No comments yet.');
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final c in comments) HnCommentTile(comment: c),
                        ],
                      );
                    },
                  ),

                  const Divider(height: 24),
                  const Text('Your Comments', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  CommentList(
                    key: commentListKey,
                    storyId: story.id,
                    onChanged: () {},
                  ),
                  CommentInput(
                    storyId: story.id,
                    onCommentAdded: () => commentListKey.currentState?.reload(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}