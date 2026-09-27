import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../providers/chat_providers.dart';

class ConnectionBanner extends ConsumerWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectionStatusProvider);

    return status.when(
      data: (value) {
        if (value == ConnectionStatus.connected) {
          return const SizedBox.shrink();
        }
        final label = value == ConnectionStatus.connecting
            ? 'Connecting…'
            : 'No connection — messages will send once you\'re back online';
        return Container(
          width: double.infinity,
          color: Colors.orange.shade700,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}