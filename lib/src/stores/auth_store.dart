import 'package:flutter/foundation.dart';
import '../services/interfaces/auth_service.dart';

class AuthStore extends ChangeNotifier {
  final AuthService auth;
  String? currentUserEmail;
  bool isLoading = false;
  AuthStore(this.auth);
  Future<void> init() async {
    currentUserEmail = await auth.currentUserEmail();
  }
  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await auth.signIn(email, password);
      currentUserEmail = email;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> signUp(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await auth.signUp(email, password);
      currentUserEmail = email;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> resetPassword(String email) async {
    await auth.resetPassword(email);
  }
  Future<void> signOut() async {
    await auth.signOut();
    currentUserEmail = null;
    notifyListeners();
  }
}
