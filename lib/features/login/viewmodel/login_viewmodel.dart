
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/login_state.dart';

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (username == 'user' && password == 'password') {
        state = state.copyWith(isLoading: false, isAuthenticated: true);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Invalid credentials');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'An error occurred');
    }
  }

  void logout() {
    state = const LoginState();
  }
}

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(LoginViewModel.new);
