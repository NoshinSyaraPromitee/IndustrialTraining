import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/conversation.dart';

/// Persists the whole chat list — every conversation and which one is
/// active — to on-device key-value storage, so history survives an app
/// restart. Swap this for a real database if history grows large enough
/// that reading/writing one JSON blob per change becomes a problem.
class ChatRepository {
  static const _conversationsKey = 'conversations';
  static const _activeIdKey = 'active_conversation_id';

  Future<List<Conversation>> loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_conversationsKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String?> loadActiveId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeIdKey);
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(conversations.map((c) => c.toJson()).toList());
    await prefs.setString(_conversationsKey, encoded);
  }

  Future<void> saveActiveId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_activeIdKey);
    } else {
      await prefs.setString(_activeIdKey, id);
    }
  }
}