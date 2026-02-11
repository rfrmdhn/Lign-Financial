import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/domain/user.dart';
import 'package:lign_financial/features/auth/domain/app_mode.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final AppMode activeMode;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.activeMode = AppMode.employee,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    AppMode? activeMode,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      activeMode: activeMode ?? this.activeMode,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Initial state: logged out
    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      user: User(id: 'u1', name: email, email: '$email@lign.com'),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = const AuthState(); // Reset
  }

  void switchMode() {
    final newMode = state.activeMode == AppMode.employee
        ? AppMode.finance
        : AppMode.employee;
    state = state.copyWith(activeMode: newMode);
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
