import 'package:equatable/equatable.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthState extends Equatable {
  const AuthState._({required this.status, this.errorMessage});

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticating()
      : this._(status: AuthStatus.authenticating);
  const AuthState.authenticated()
      : this._(status: AuthStatus.authenticated);
  const AuthState.error(String message)
      : this._(status: AuthStatus.error, errorMessage: message);

  final AuthStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}