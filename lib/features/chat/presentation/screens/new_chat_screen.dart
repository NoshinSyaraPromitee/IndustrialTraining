import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import 'channel_screen.dart';

class NewChatScreen extends ConsumerStatefulWidget {
  const NewChatScreen({super.key});

  @override
  ConsumerState<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends ConsumerState<NewChatScreen> {
  final _controller = TextEditingController();
  List<User> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    final client = ref.read(streamClientProvider);
    final response = await client.queryUsers(
      filter: Filter.and([
        Filter.notEqual('id', client.state.currentUser!.id),
        Filter.autoComplete('name', query.trim()),
      ]),
      sort: [const SortOption('name')],
      pagination: PaginationParams(limit: 15),
    );
    if (!mounted) return;
    setState(() {
      _results = response.users;
      _loading = false;
    });
  }

  Future<void> _startChat(User otherUser) async {
    final client = ref.read(streamClientProvider);
    final currentUser = client.state.currentUser!;
    final members = [currentUser.id, otherUser.id]..sort();
    final channel = client.channel(
      'messaging',
      id: 'dm-${members.join('-')}',
      extraData: {'members': members},
    );
    await channel.watch();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            StreamChannel(channel: channel, child: const ChannelScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New chat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _search,
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final user = _results[index];
                return ListTile(
                  leading: StreamUserAvatar(user: user),
                  title: Text(user.name),
                  onTap: () => _startChat(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
