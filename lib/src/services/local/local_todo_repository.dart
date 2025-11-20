import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../errors.dart';
import '../../models.dart';
import '../interfaces/todo_repository.dart';

class LocalTodoRepository implements TodoRepository {
  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();
  static const _todosKey = 'todos_v1';
  final Map<String, StreamController<List<Todo>>> _streams = {};
  @override
  Future<List<Todo>> fetchAll(String userId) async {
    final p = await _p;
    final raw = p.getString(_todosKey);
    if (raw == null) return [];
    final list = List<Map<String, dynamic>>.from(json.decode(raw));
    final todos = list.map((e) => Todo.fromMap(e)).where((t) => t.userId == userId).toList();
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
  Future<void> _emit(String userId) async {
    final list = await fetchAll(userId);
    _streams[userId]?.add(List.unmodifiable(list));
  }
  @override
  Stream<List<Todo>> watchAll(String userId) {
    _streams[userId] ??= StreamController<List<Todo>>.broadcast();
    unawaited(_emit(userId));
    return _streams[userId]!.stream;
  }
  @override
  Future<void> add(String userId, String title, String? notes) async {
    final all = await _fetchAllRaw();
    final now = DateTime.now();
    final t = Todo(id: const Uuid().v4(), userId: userId, title: title, notes: notes, isDone: false, createdAt: now, updatedAt: now);
    all.add(t);
    await _saveAll(all);
    await _emit(userId);
  }
  @override
  Future<void> update(Todo todo) async {
    final all = await _fetchAllRaw();
    final idx = all.indexWhere((e) => e.id == todo.id);
    if (idx < 0) throw AppFailure('not_found', 'Introuvable');
    all[idx] = todo.copyWith(updatedAt: DateTime.now());
    await _saveAll(all);
    await _emit(todo.userId);
  }
  @override
  Future<void> delete(String id) async {
    final all = await _fetchAllRaw();
    final removed = all.firstWhere((e) => e.id == id, orElse: () => throw AppFailure('not_found', 'Introuvable'));
    all.removeWhere((e) => e.id == id);
    await _saveAll(all);
    await _emit(removed.userId);
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
    await _emit(t.userId);
  }
}