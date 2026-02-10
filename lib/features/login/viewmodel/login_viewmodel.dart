import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/login_state.dart';

/// Login ViewModel
/// Manages state and handles user interaction.
/// Uses Riverpod StateNotifier to expose state.
class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  void onUsernameChanged(String value) {
    state = state.copyWith(username: value);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate API Call (Repository call would go here)
      await Future.delayed(const Duration(seconds: 2));

      if (state.username == 'admin' && state.password == 'password') {
         state = state.copyWith(isLoading: false, isAuthenticated: true);
      } else {
         state = state.copyWith(isLoading: false, errorMessage: 'Invalid credentials');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

/// Provider for the LoginViewModel
final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(() {
  return LoginViewModel();
});
