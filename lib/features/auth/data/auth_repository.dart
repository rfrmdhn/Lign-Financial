import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { employee, finance, founder }

class User {
  final String id;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.role,
  });
}

class AuthState {
  final User? user;
  const AuthState(this.user);
}

class AuthNotifier extends Notifier<AuthState> {
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

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
