import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/i_auth_service.dart';

class AuthStore extends ChangeNotifier {
  final IAuthService _service;
  AppUser? _current;
  bool _loading = true;
  Object? _error;

  AuthStore(this._service) {
    _service.authStateChanges().listen((u) {
      _current = u;
      _loading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e;
      _loading = false;
      notifyListeners();
    });
  }

  AppUser? get current => _current;
  bool get isLoading => _loading;
  Object? get error => _error;

  Future<void> signIn(String email, String password) => _service.signIn(email, password);
  Future<void> signUp(String email, String password) => _service.signUp(email, password);
  Future<void> signOut() => _service.signOut();
}
