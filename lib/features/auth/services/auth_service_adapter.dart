import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../src/services/interfaces/auth_service.dart' as c;
import '../models/app_user.dart';
import 'i_auth_service.dart';

class AuthServiceAdapter implements IAuthService {
  final c.AuthService _inner;
  final _ctrl = StreamController<AppUser?>.broadcast();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _currentId;
  String? _currentEmail;
  AuthServiceAdapter(this._inner) {
    _ctrl.add(null);
    _firebaseAuth.authStateChanges().listen((user) {
      unawaited(_emitFromFirebase(user));
    });
    unawaited(_emit());
  }
  @override
  Stream<AppUser?> authStateChanges() => _ctrl.stream;
  Future<void> _emit() async {
    await _emitFromFirebase(_firebaseAuth.currentUser);
  }

  Future<void> _emitFromFirebase(User? user) async {
    if (user == null) {
      if (_currentId != null || _currentEmail != null) {
        _currentId = null;
        _currentEmail = null;
        _ctrl.add(null);
      }
      return;
    }
    final email = user.email ?? await _inner.currentUserEmail() ?? '';
    final id = user.uid;
    if (id != _currentId || email != _currentEmail) {
      _currentId = id;
      _currentEmail = email;
      _ctrl.add(AppUser(id: id, email: email));
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
  Future<void> resetPassword(String email) => _inner.resetPassword(email);
  @override
  Future<void> signOut() async {
    await _inner.signOut();
    await _emit();
  }
}

