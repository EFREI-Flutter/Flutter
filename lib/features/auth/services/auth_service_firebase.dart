import '../models/app_user.dart';
import 'i_auth_service.dart';

class AuthServiceFirebase implements IAuthService {
  @override
  Stream<AppUser?> authStateChanges() => throw UnimplementedError();

  @override
  Future<void> signIn(String email, String password) => throw UnimplementedError();

  @override
  Future<void> signUp(String email, String password) => throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();
}
