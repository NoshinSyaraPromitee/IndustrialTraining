import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../widgets/message_builder.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen({super.key, required this.parent});

  final Message parent;

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  late final StreamMessageInputController _inputController;

  @override
  void initState() {
    super.initState();
    // Seeding the controller with parentId puts the composer in "reply"
    // mode — outgoing messages are posted as replies to widget.parent.
    _inputController = StreamMessageInputController(
      message: Message(parentId: widget.parent.id),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamThreadHeader(parent: widget.parent),
      body: Column(
        children: [
          Expanded(
            child: StreamMessageListView(parentMessage: widget.parent),
          ),
          StreamMessageInput(messageInputController: _inputController),
        ],
      ),
    );
  }
}