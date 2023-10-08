import 'package:equatable/equatable.dart';

enum PageStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final PageStatus status; // inicial, cargando, éxito, falla
  final bool loginSuccess;
  final String? errorMessage;
  final Exception? exception;
  final String? authToken;
  final String? refreshToken;

  const LoginState({
    this.status = PageStatus.initial,
    this.loginSuccess = false,
    this.errorMessage,
    this.exception,
    this.authToken,
    this.refreshToken,
  });

  LoginState copyWith({
    PageStatus? status,
    bool? loginSuccess,
    String? errorMessage,
    Exception? exception,
    String? authToken,
    String? refreshToken,
  }) {
    return LoginState(
      status: status ?? this.status,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      exception: exception ?? this.exception,
      authToken: authToken ?? this.authToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [
        status,
        loginSuccess,
        errorMessage,
        exception,
        authToken,
        refreshToken,
      ];
}
