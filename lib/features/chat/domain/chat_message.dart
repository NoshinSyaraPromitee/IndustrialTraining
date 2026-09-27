/// Who sent a [ChatMessage].
enum ChatRole { user, assistant }

/// A single message in the conversation with the AI assistant.
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.isStreaming = false,
  });

  final String id;
  final ChatRole role;
  final String text;
  final bool isStreaming;

  ChatMessage copyWith({String? text, bool? isStreaming}) {
    return ChatMessage(
      id: id,
      role: role,
      text: text ?? this.text,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  /// isStreaming is deliberately left out — a reloaded message is always
  /// finished streaming.
  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'text': text,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        role: ChatRole.values.byName(json['role'] as String),
        text: json['text'] as String,
      );
}