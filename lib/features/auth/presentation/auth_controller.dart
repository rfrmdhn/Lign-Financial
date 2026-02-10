import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/data/auth_repository.dart';

class AuthState {
  final User? user;
  final AppMode activeMode;

  const AuthState({
    this.user,
    this.activeMode = AppMode.finance,
  });

  AuthState copyWith({
    User? user,
    AppMode? activeMode,
  }) {
    return AuthState(
      user: user ?? this.user,
      activeMode: activeMode ?? this.activeMode,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// Mock login — accepts any non-empty username/password.
  /// Defaults to Finance mode after login.
  void login(String username, String password) {
    state = AuthState(
      user: User(
        id: '1',
        name: username,
        email: '$username@lign.co',
      ),
      activeMode: AppMode.finance,
    );
  }

  void switchMode() {
    if (state.user == null) return;
    state = state.copyWith(
      activeMode: state.activeMode == AppMode.finance
          ? AppMode.employee
          : AppMode.finance,
    );
  }

  void logout() {
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
