
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Nullable to clear error
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
