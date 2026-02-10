/// Auth Repository Interface
/// Defines the contract for authentication operations.
abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
}
