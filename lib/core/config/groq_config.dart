/// Groq API configuration.
///
/// IMPORTANT: unlike Stream's public API key, an LLM provider key like this
/// IS a genuine secret — anyone inspecting network traffic or decompiling
/// this app can extract it and rack up usage on your account. For a real
/// product, proxy calls through your own backend so the key never reaches
/// the client. For a class assignment, passing it at build time (never
/// hardcoding it in source) is the minimum acceptable safeguard.
class GroqConfig {
  GroqConfig._();

  static const String apiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: 'REPLACE_WITH_YOUR_GROQ_API_KEY',
  );

  static const String model = String.fromEnvironment(
    'GROQ_MODEL',
    defaultValue: 'openai/gpt-oss-120b',
  );
}