import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injector.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../domain/entities/story.dart';

class StoryCard extends StatefulWidget {
  final Story story;
  final int imageIndex;

  const StoryCard({super.key, required this.story, required this.imageIndex});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  @override
  void initState() {
    super.initState();
    // Seeds the shared store with this story's persisted local count the
    // first time the card appears; a no-op if it's already cached.
    Injector.commentCountStore.ensureLoaded(widget.story.id);
  }

  void _openDetail() {
    context.push(
      '/story/${widget.story.id}?imageIndex=${widget.imageIndex}',
      extra: widget.story,
    );
    // No manual refresh on return needed: CommentInput calls
    // commentCountStore.increment() the instant a comment is added, and
    // this card is listening to that same store below.
  }

  String get imagePath {
    final number = (widget.imageIndex % 5) + 1;
    return 'assets/images/tech$number.png';
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openDetail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, width: double.infinity, height: 180, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('by ${story.author}'),
                  const SizedBox(height: 6),
                  Text('${story.score} points • ${TimeFormatter.timeAgo(story.time)}'),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}