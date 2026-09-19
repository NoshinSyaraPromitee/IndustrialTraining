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
  late Future<int> localCount;

  @override
  void initState() {
    super.initState();
    localCount = Injector.getLocalCommentCount(widget.story.id);
  }

  Future<void> _openDetail() async {
    // Push a real route — this is what makes the card "expand to a new page".
    await context.push(
      '/story/${widget.story.id}?imageIndex=${widget.imageIndex}',
      extra: widget.story,
    );

    // Refresh in case a local comment was added on the detail screen.
    setState(() {
      localCount = Injector.getLocalCommentCount(widget.story.id);
    });
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
                  FutureBuilder<int>(
                    future: localCount,
                    builder: (context, snapshot) {
                      final local = snapshot.data ?? 0;
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