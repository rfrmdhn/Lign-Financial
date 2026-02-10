/// Login State Model
/// Defines the state of the Login feature.
/// This is a pure data class (DTO) and contains NO logic.
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  final String username;
  final String password;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
    this.username = '',
    this.password = '',
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
    String? username,
    String? password,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
