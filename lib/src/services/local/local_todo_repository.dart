import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../errors.dart';
import '../interfaces/todo_repository.dart';
import '../../models.dart';
import 'package:uuid/uuid.dart';

class LocalTodoRepository implements TodoRepository {
  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();
  static const _todosKey = 'todos_v1';
  @override
  Future<List<Todo>> fetchAll(String userEmail) async {
    final p = await _p;
    final raw = p.getString(_todosKey);
    if (raw == null) return [];
    final list = List<Map<String, dynamic>>.from(json.decode(raw));
    final todos = list.map((e) => Todo.fromMap(e)).where((t) => t.userEmail == userEmail).toList();
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todos;
  }
  Future<void> _saveAll(List<Todo> all) async {
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
  @override
  Future<void> add(String userEmail, String title, String? notes) async {
    final all = await _fetchAllRaw();
    final now = DateTime.now();
    final t = Todo(id: const Uuid().v4(), userEmail: userEmail, title: title, notes: notes, isDone: false, createdAt: now, updatedAt: now);
    all.add(t);
    await _saveAll(all);
  }
  @override
  Future<void> update(Todo todo) async {
    final all = await _fetchAllRaw();
    final idx = all.indexWhere((e) => e.id == todo.id);
    if (idx < 0) throw AppFailure('not_found', 'Introuvable');
    all[idx] = todo.copyWith(updatedAt: DateTime.now());
    await _saveAll(all);
  }
  @override
  Future<void> delete(String id) async {
    final all = await _fetchAllRaw();
    all.removeWhere((e) => e.id == id);
    await _saveAll(all);
  }
  @override
  Future<Todo?> getById(String id) async {
    final all = await _fetchAllRaw();
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
  @override
  Future<void> toggle(String id) async {
    final all = await _fetchAllRaw();
    final idx = all.indexWhere((e) => e.id == id);
    if (idx < 0) throw AppFailure('not_found', 'Introuvable');
    final t = all[idx];
    all[idx] = t.copyWith(isDone: !t.isDone, updatedAt: DateTime.now());
    await _saveAll(all);
  }
}
