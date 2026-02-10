import 'package:lign_financial/features/auth/domain/user.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<void> logout();
}
