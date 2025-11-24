import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../errors.dart';
import '../interfaces/auth_service.dart';

class LocalAuthService implements AuthService {
  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();
  static const _usersKey = 'users';
  static const _currentKey = 'current_user_email';
  @override
  Future<void> ensureTestUser({required String email, required String password}) async {
    final p = await _p;
    final raw = p.getString(_usersKey);
    final map = raw == null ? <String, String>{} : Map<String, String>.from(json.decode(raw));
    if (!map.containsKey(email)) {
      map[email] = password;
      await p.setString(_usersKey, json.encode(map));
    }
    await p.setString(_currentKey, email);
  }
  @override
  Future<String?> currentUserId() async {
    return currentUserEmail();
  }
  @override
  Future<String?> currentUserEmail() async {
    final p = await _p;
    return p.getString(_currentKey);
  }
  @override
  Future<void> signOut() async {
    final p = await _p;
    await p.remove(_currentKey);
  }
  @override
  Future<void> signIn(String email, String password) async {
    final p = await _p;
    final raw = p.getString(_usersKey);
    final map = raw == null ? <String, String>{} : Map<String, String>.from(json.decode(raw));
    if (!map.containsKey(email) || map[email] != password) {
      throw AppFailure('invalid_credentials', 'Identifiants invalides');
    }
    await p.setString(_currentKey, email);
  }
  @override
  Future<void> signUp(String email, String password) async {
    final p = await _p;
    final raw = p.getString(_usersKey);
    final map = raw == null ? <String, String>{} : Map<String, String>.from(json.decode(raw));
    if (map.containsKey(email)) {
      throw AppFailure('email_exists', 'Email déjà utilisé');
    }
    map[email] = password;
    await p.setString(_usersKey, json.encode(map));
    await p.setString(_currentKey, email);
  }
  @override
  Future<void> resetPassword(String email) async {
    final p = await _p;
    final raw = p.getString(_usersKey);
    final map = raw == null ? <String, String>{} : Map<String, String>.from(json.decode(raw));
    if (!map.containsKey(email)) {
      throw AppFailure('not_found', 'Email inconnu');
    }
  }
}