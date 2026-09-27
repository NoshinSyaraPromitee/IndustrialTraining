/// Stream Chat configuration.
///
/// IMPORTANT: never hardcode a real key here for a submitted project — pass
/// it at build time. In production the user *token* must also be minted by
/// your backend using the API *secret* (Stream's server SDK). `devToken()`
/// used later in this app is a documented dev-only shortcut and is NOT
/// secure auth — see auth_providers.dart.
class StreamConfig {
  StreamConfig._();

  static const String apiKey = String.fromEnvironment(
    'STREAM_API_KEY',
    defaultValue: '',
  );
}
