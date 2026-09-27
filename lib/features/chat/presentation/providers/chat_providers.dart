import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../auth/presentation/providers/auth_providers.dart';

/// Exposes the socket's live connection status as Riverpod state so any
/// widget can reactively show "reconnecting" banners without polling.
final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final client = ref.watch(streamClientProvider);
  return client.wsConnectionStatusStream;
});