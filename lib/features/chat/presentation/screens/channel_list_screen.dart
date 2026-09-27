import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/connection_banner.dart';
import 'channel_screen.dart';
import 'new_chat_screen.dart';

class ChannelListScreen extends ConsumerStatefulWidget {
  const ChannelListScreen({super.key});

  @override
  ConsumerState<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends ConsumerState<ChannelListScreen> {
  StreamChannelListController? _controller;

  StreamChannelListController _controllerFor(BuildContext context) {
    return _controller ??= StreamChannelListController(
      client: StreamChat.of(context).client,
      filter: Filter.in_(
        'members',
        [StreamChat.of(context).currentUser!.id],
      ),
      channelStateSort: const [SortOption('last_message_at')],
      limit: 20,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controllerFor(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NewChatScreen()),
        ),
        child: const Icon(Icons.add_comment),
      ),
      body: Column(
        children: [
          const ConnectionBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refresh,
              child: StreamChannelListView(
                controller: controller,
                onChannelTap: (channel) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StreamChannel(
                      channel: channel,
                      child: const ChannelScreen(),
                    ),
                  ),
                ),
                emptyBuilder: (context) => const Center(
                  child: Text('No conversations yet. Tap + to start one.'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}