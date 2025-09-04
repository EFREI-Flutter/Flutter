import 'package:firebase_auth/firebase_auth.dart';
import 'i_auth_service.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _fa;
  FirebaseAuthService(this._fa);

  @override
  Stream<User?> authStateChanges() => _fa.authStateChanges();

  @override
  Future<void> signIn(String email, String password) =>
      _fa.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signUp(String email, String password) =>
      _fa.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> sendPasswordReset(String email) =>
      _fa.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() => _fa.signOut();
}
