import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../core/config/stream_config.dart';
import '../../application/auth_state.dart';

/// Single shared StreamChatClient for the whole app's lifetime.
final streamClientProvider = Provider<StreamChatClient>((ref) {
  final client = StreamChatClient(
    StreamConfig.apiKey,
    logLevel: Level.WARNING,
  );
  ref.onDispose(client.dispose);
  return client;
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(streamClientProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._client) : super(const AuthState.unauthenticated());

  final StreamChatClient _client;

  Future<void> login({required String userId, required String name}) async {
    final id = userId.trim();
    if (id.isEmpty) {
      state = const AuthState.error('User ID cannot be empty');
      return;
    }
    state = const AuthState.authenticating();
    try {
      final user = User(id: id, extraData: {'name': name.trim()});
      // DEV-ONLY token generation. Replace with a backend-issued JWT
      // before this ever ships to real users.
      final token = _client.devToken(user.id);
      await _client.connectUser(user, token.rawValue);
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    await _client.disconnectUser();
    state = const AuthState.unauthenticated();
  }
}