import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/application/auth_state.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/chat/presentation/screens/channel_list_screen.dart';

class ChatApp extends ConsumerWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(streamClientProvider);
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      title: 'Flutter Stream Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: StreamChat(
        client: client,
        child: authState.status == AuthStatus.authenticated
            ? const ChannelListScreen()
            : const LoginScreen(),
      ),
    );
  }
}