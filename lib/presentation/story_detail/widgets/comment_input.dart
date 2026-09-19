import 'package:flutter/material.dart';
import '../../../core/di/injector.dart';

class CommentInput extends StatefulWidget {
  final int storyId;
  final VoidCallback onCommentAdded;
  final int? parentId;

  const CommentInput({
    super.key,
    required this.storyId,
    required this.onCommentAdded,
    this.parentId,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    await Injector.addLocalComment(widget.storyId, text, parentId: widget.parentId);

    controller.clear();
    widget.onCommentAdded();

    if (mounted) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: widget.parentId == null ? 'Write a comment...' : 'Write a reply...',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(onPressed: _addComment, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}