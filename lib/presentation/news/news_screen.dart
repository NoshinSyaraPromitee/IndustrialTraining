import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../domain/entities/story.dart';
import 'widgets/story_card.dart';

class NewsScreen extends StatefulWidget {
  final String type;
  const NewsScreen({super.key, required this.type});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Story>> stories;

  @override
  void initState() {
    super.initState();
    stories = _loadStories();
  }

  Future<List<Story>> _loadStories() {
    switch (widget.type) {
      case 'Top':
        return Injector.getTopStories();
      case 'New':
        return Injector.getNewStories();
      case 'Best':
      default:
        return Injector.getBestStories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} News'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Story>>(
        future: stories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load news.\nCheck your internet connection.',
                textAlign: TextAlign.center,
              ),
            );
          }

          final news = snapshot.data ?? [];

          if (news.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => stories = _loadStories());
              await stories;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: news.length,
              itemBuilder: (context, index) {
                return StoryCard(story: news[index], imageIndex: index);
              },
            ),
          );
        },
      ),
    );
  }
}