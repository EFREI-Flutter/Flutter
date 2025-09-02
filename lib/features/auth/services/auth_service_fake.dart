import 'dart:async';
import '../models/app_user.dart';
import 'i_auth_service.dart';

class AuthServiceFake implements IAuthService {
  final _ctrl = StreamController<AppUser?>.broadcast();
  AppUser? _current;

  @override
  Stream<AppUser?> authStateChanges() => _ctrl.stream;

  @override
  Future<void> signIn(String email, String password) async {
    _current = AppUser(id: 'uid_${email.hashCode}', email: email);
    _ctrl.add(_current);
  }

  @override
  Future<void> signUp(String email, String password) async => signIn(email, password);

  @override
  Future<void> signOut() async {
    _current = null;
    _ctrl.add(null);
  }
}
