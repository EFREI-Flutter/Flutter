import 'package:flutter/foundation.dart';
import '../services/services.dart';

class AuthStore extends ChangeNotifier {
  final LocalAuthService _auth = LocalAuthService();
  String? currentUserEmail;
  bool isLoading = false;
  Future<void> init() async {
    currentUserEmail = await _auth.currentUserEmail();
  }
  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _auth.signIn(email, password);
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
      await _auth.signUp(email, password);
      currentUserEmail = email;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> resetPassword(String email) async {
    await _auth.resetPassword(email);
  }
  Future<void> signOut() async {
    await _auth.signOut();
    currentUserEmail = null;
    notifyListeners();
  }
}
