import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models.dart';

class LocalAuthService {
  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();
  static const _usersKey = 'users';
  static const _currentKey = 'current_user_email';
  Future<String?> currentUserEmail() async {
    final p = await _p;
    return p.getString(_currentKey);
    }
  Future<void> signOut() async {
    final p = await _p;
    await p.remove(_currentKey);
  }
  Future<void> signIn(String email, String password) async {
    final p = await _p;
    final raw = p.getString(_usersKey);
    final map = raw == null ? <String, String>{} : Map<String, String>.from(json.decode(raw));
    if (!map.containsKey(email) || map[email] != password) {
      throw Exception('invalid_credentials');
    }
    await p.setString(_currentKey, email);
  }
  Future<void> signUp(String email, String password) async {
    final p = await _p;
    final raw = p.getString(_usersKey);
    final map = raw == null ? <String, String>{} : Map<String, String>.from(json.decode(raw));
    if (map.containsKey(email)) {
      throw Exception('email_exists');
    }
    map[email] = password;
    await p.setString(_usersKey, json.encode(map));
    await p.setString(_currentKey, email);
  }
  Future<void> resetPassword(String email) async {
    final p = await _p;
    final raw = p.getString(_usersKey);
    final map = raw == null ? <String, String>{} : Map<String, String>.from(json.decode(raw));
    if (!map.containsKey(email)) {
      throw Exception('not_found');
    }
  }
}

class LocalTodoRepository {
  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();
  static const _todosKey = 'todos_v1';
  Future<List<Todo>> fetchAll(String userEmail) async {
    final p = await _p;
    final raw = p.getString(_todosKey);
    if (raw == null) return [];
    final list = List<Map<String, dynamic>>.from(json.decode(raw));
    final todos = list.map((e) => Todo.fromMap(e)).where((t) => t.userEmail == userEmail).toList();
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todos;
  }
  Future<void> saveAll(List<Todo> all) async {
    final p = await _p;
    final raw = json.encode(all.map((e) => e.toMap()).toList());
    await p.setString(_todosKey, raw);
  }
  Future<List<Todo>> _fetchAllRaw() async {
    final p = await _p;
    final raw = p.getString(_todosKey);
    if (raw == null) return [];
    final list = List<Map<String, dynamic>>.from(json.decode(raw));
    return list.map((e) => Todo.fromMap(e)).toList();
  }
  Future<void> add(String userEmail, String title, String? notes) async {
    final all = await _fetchAllRaw();
    final now = DateTime.now();
    final t = Todo(id: const Uuid().v4(), userEmail: userEmail, title: title, notes: notes, isDone: false, createdAt: now, updatedAt: now);
    all.add(t);
    await saveAll(all);
  }
  Future<void> update(Todo todo) async {
    final all = await _fetchAllRaw();
    final idx = all.indexWhere((e) => e.id == todo.id);
    if (idx >= 0) {
      all[idx] = todo.copyWith(updatedAt: DateTime.now());
      await saveAll(all);
    }
  }
  Future<void> delete(String id) async {
    final all = await _fetchAllRaw();
    all.removeWhere((e) => e.id == id);
    await saveAll(all);
  }
  Future<Todo?> getById(String id) async {
    final all = await _fetchAllRaw();
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
  Future<void> toggle(String id) async {
    final all = await _fetchAllRaw();
    final idx = all.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      final t = all[idx];
      all[idx] = t.copyWith(isDone: !t.isDone, updatedAt: DateTime.now());
      await saveAll(all);
    }
  }
}
