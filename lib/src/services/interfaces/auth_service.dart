abstract class AuthService {
  Future<void> ensureTestUser({required String email, required String password});
  Future<String?> currentUserId();
  Future<String?> currentUserEmail();
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}