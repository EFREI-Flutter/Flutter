import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Stream<User?> authStateChanges();
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}
