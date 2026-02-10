import 'auth_repository.dart';

/// Mock Implementation of Auth Repository
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'admin' && password == 'password') {
      return;
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<bool> isAuthenticated() async {
    // Mock check
    return false;
  }
}
