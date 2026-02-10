import 'package:lign_financial/features/auth/domain/auth_repository.dart';
import 'package:lign_financial/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User?> login(String username, String password) async {
    // Mock simulation
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: '1',
      name: username,
      email: '$username@lign.co',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
