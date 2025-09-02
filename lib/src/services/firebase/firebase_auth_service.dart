import '../interfaces/auth_service.dart';

class FirebaseAuthService implements AuthService {
  @override
  Future<String?> currentUserEmail() async {
    throw UnimplementedError();
  }
  @override
  Future<void> signIn(String email, String password) async {
    throw UnimplementedError();
  }
  @override
  Future<void> signUp(String email, String password) async {
    throw UnimplementedError();
  }
  @override
  Future<void> resetPassword(String email) async {
    throw UnimplementedError();
  }
  @override
  Future<void> signOut() async {
    throw UnimplementedError();
  }
}
