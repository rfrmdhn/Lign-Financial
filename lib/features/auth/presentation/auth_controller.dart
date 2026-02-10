import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/data/auth_repository.dart';

class AuthState {
  final User? user;
  const AuthState(this.user);
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(null);
  }

  void login(UserRole role) {
    state = AuthState(User(
      id: '1',
      name: role == UserRole.employee ? 'Employee User' : 'Finance User',
      role: role,
    ));
  }

  void logout() {
    state = const AuthState(null);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
