import 'package:flutter/material.dart';
import '../../../core/di/injector.dart';
import '../../../domain/entities/local_comment.dart';
import 'comment_tile.dart';

class CommentList extends StatefulWidget {
  final int storyId;
  final VoidCallback onChanged;

  const CommentList({super.key, required this.storyId, required this.onChanged});

  @override
  State<CommentList> createState() => CommentListState();
}

class CommentListState extends State<CommentList> {
  late Future<List<LocalComment>> future;

  @override
  void initState() {
    super.initState();
    future = Injector.getLocalComments(widget.storyId);
  }

  void reload() {
    setState(() => future = Injector.getLocalComments(widget.storyId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LocalComment>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          );
        }

        final comments = snapshot.data ?? [];

        if (comments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('No local comments yet.'),
          );
        }

        final byParent = <int?, List<LocalComment>>{};
        for (final c in comments) {
          byParent.putIfAbsent(c.parentId, () => []).add(c);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildThread(byParent, null, 0),
        );
      },
    );
  }

  List<Widget> _buildThread(
    Map<int?, List<LocalComment>> byParent,
    int? parentId,
    int depth,
  ) {
    final children = byParent[parentId] ?? [];
    final widgets = <Widget>[];

    for (final comment in children) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(left: depth * 16.0, bottom: 8),
          child: CommentTile(
            comment: comment,
            storyId: widget.storyId,
            onChanged: () {
              reload();
              widget.onChanged();
            },
          ),
        ),
      );
      widgets.addAll(_buildThread(byParent, comment.id, depth + 1));
    }

    return widgets;
  }
}