import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/domain/app_mode.dart';
import 'package:lign_financial/features/auth/domain/auth_repository.dart';
import 'package:lign_financial/features/auth/domain/user.dart';
import 'package:lign_financial/features/auth/data/auth_repository_impl.dart';

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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> login(String username, String password) async {
    final repository = ref.read(authRepositoryProvider);
    final user = await repository.login(username, password);
    
    if (user != null) {
      state = AuthState(
        user: user,
        activeMode: AppMode.finance,
      );
    }
  }

  void switchMode() {
    if (state.user == null) return;
    state = state.copyWith(
      activeMode: state.activeMode == AppMode.finance
          ? AppMode.employee
          : AppMode.finance,
    );
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
