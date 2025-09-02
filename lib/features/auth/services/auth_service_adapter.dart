import 'dart:async';
import '../../../src/services/interfaces/auth_service.dart' as c;
import '../models/app_user.dart';
import 'i_auth_service.dart';

class AuthServiceAdapter implements IAuthService {
  final c.AuthService _inner;
  final _ctrl = StreamController<AppUser?>.broadcast();
  StreamSubscription<String?>? _sub;
  String? _currentEmail;
  AuthServiceAdapter(this._inner) {
    // no direct stream in C; emulate with polling on demand
    // emit null initially; real updates come from explicit calls
    _ctrl.add(null);
  }
  @override
  Stream<AppUser?> authStateChanges() => _ctrl.stream;
  Future<void> _emit() async {
    final email = await _inner.currentUserEmail();
    if (email != _currentEmail) {
      _currentEmail = email;
      _ctrl.add(email == null ? null : AppUser(id: email, email: email));
    }
  }
  @override
  Future<void> signIn(String email, String password) async {
    await _inner.signIn(email, password);
    await _emit();
  }
  @override
  Future<void> signUp(String email, String password) async {
    await _inner.signUp(email, password);
    await _emit();
  }
  @override
  Future<void> signOut() async {
    await _inner.signOut();
    await _emit();
  }
}
