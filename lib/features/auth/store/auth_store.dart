import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/i_auth_service.dart';

class AuthStore extends ChangeNotifier {
  final IAuthService service;
  StreamSubscription<AppUser?>? _sub;
  AppUser? currentUser;
  bool isLoading = false;

  AuthStore(this.service) {
    _sub = service.authStateChanges().listen((u) {
      currentUser = u;
      notifyListeners();
    });
  }

  String? get currentUserEmail => currentUser?.email;
  String? get currentUserId => currentUser?.id;

  Future<void> init() async {}

  Future<void> signIn(String email, String password) async {
    final normalizedEmail = email.trim();
    isLoading = true;
    notifyListeners();
    try {
      await service.signIn(normalizedEmail, password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    final normalizedEmail = email.trim();
    isLoading = true;
    notifyListeners();
    try {
      await service.signUp(normalizedEmail, password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) => service.resetPassword(email.trim());

  Future<void> signOut() => service.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

