import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/i_auth_service.dart';

class AuthStoreB extends ChangeNotifier {
  final IAuthService service;
  StreamSubscription<AppUser?>? _sub;
  AppUser? currentUser;
  bool isLoading = false;

  AuthStoreB(this.service) {
    _sub = service.authStateChanges().listen((u) {
      currentUser = u;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await service.signIn(email, password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await service.signUp(email, password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() => service.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
