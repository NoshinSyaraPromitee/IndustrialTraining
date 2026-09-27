import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/groq_config.dart';
import '../domain/chat_message.dart';

/// Talks to Groq's OpenAI-compatible streaming chat-completions endpoint
/// and yields incremental text chunks as they arrive over the wire.
class GroqChatService {
  GroqChatService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  /// Streams response text chunks given the conversation so far.
  ///
  /// [history] must be ordered oldest-first with only 'user'/'assistant'
  /// messages already sent — do not include a placeholder for the reply
  /// being generated.
  Stream<String> streamReply(List<ChatMessage> history) async* {
    final request = http.Request('POST', Uri.parse(_endpoint))
      ..headers.addAll({
        'Authorization': 'Bearer ${GroqConfig.apiKey}',
        'Content-Type': 'application/json',
      })
      ..body = jsonEncode({
        'model': GroqConfig.model,
        'stream': true,
        'messages': [
          for (final m in history) {'role': m.role.name, 'content': m.text},
        ],
      });

    final response = await _client.send(request);
    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw Exception('Groq error ${response.statusCode}: $body');
    }

    final lines = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      if (!line.startsWith('data: ')) continue;
      final payload = line.substring(6).trim();
      if (payload.isEmpty) continue;
      if (payload == '[DONE]') break;

      final json = jsonDecode(payload) as Map<String, dynamic>;
      final choices = json['choices'] as List<dynamic>?;
      final delta = choices?.first['delta']?['content'] as String?;
      if (delta != null && delta.isNotEmpty) yield delta;
    }
  }
}