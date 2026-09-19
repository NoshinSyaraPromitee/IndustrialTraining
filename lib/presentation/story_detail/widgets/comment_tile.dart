import 'package:flutter/material.dart';
import '../../../domain/entities/local_comment.dart';
import 'comment_input.dart';

class CommentTile extends StatefulWidget {
  final LocalComment comment;
  final int storyId;
  final VoidCallback onChanged;

  const CommentTile({
    super.key,
    required this.comment,
    required this.storyId,
    required this.onChanged,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool replying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.comment.text),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => setState(() => replying = !replying),
                child: Text(
                  replying ? 'Cancel' : 'Reply',
                  style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        if (replying)
          CommentInput(
            storyId: widget.storyId,
            parentId: widget.comment.id,
            onCommentAdded: () {
              setState(() => replying = false);
              widget.onChanged();
            },
          ),
      ],
    );
  }
}