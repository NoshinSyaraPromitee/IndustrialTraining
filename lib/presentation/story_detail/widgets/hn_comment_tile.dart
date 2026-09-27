import 'package:flutter/material.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../domain/entities/comment.dart';

/// Renders one real HN comment plus all of its replies, indented by depth.
class HnCommentTile extends StatelessWidget {
  final Comment comment;
  final int depth;

  const HnCommentTile({super.key, required this.comment, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    if (comment.deleted) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.author ?? 'unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(_stripHtml(comment.text)),
                const SizedBox(height: 4),
                Text(
                  TimeFormatter.timeAgo(comment.time),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          for (final reply in comment.replies)
            HnCommentTile(comment: reply, depth: depth + 1),
        ],
      ),
    );
  }

  String _stripHtml(String text) =>
      text.replaceAll('<p>', '\n\n').replaceAll(RegExp(r'<[^>]*>'), '');
}