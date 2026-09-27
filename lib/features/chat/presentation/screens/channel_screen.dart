import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'thread_screen.dart';
import '../widgets/message_builder.dart';

class ChannelScreen extends StatelessWidget {
  const ChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: [
          Expanded(
            child: StreamMessageListView(
              threadBuilder: (context, parentMessage) =>
                  ThreadScreen(parent: parentMessage!),
            ),
          ),
          const StreamMessageInput(),
        ],
      ),
    );
  }
}