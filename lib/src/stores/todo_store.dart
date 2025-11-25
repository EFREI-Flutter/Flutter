import 'dart:async';

import 'package:efrei_todo/features/auth/store/auth_store.dart';
import 'package:flutter/foundation.dart';

import '../models.dart';
import '../services/interfaces/todo_repository.dart';

class TodoStore extends ChangeNotifier {
  final TodoRepository repo;
  final AuthStore auth;
  List<Todo> todos = [];
  bool isBusy = false;
  StreamSubscription<List<Todo>>? _sub;
  TodoStore(this.repo, this.auth);

  Future<void> init() async {
    auth.addListener(_handleAuthChange);
    await _bindStream();
  }

  Future<void> _bindStream() async {
    await _sub?.cancel();
    final userId = auth.currentUserId;
    if (userId == null) {
      todos = [];
      notifyListeners();
      return;
    }
    isBusy = true;
    notifyListeners();
    _sub = repo.watchAll(userId).listen((list) {
      todos = list;
      isBusy = false;
      notifyListeners();
    });
  }

  void _handleAuthChange() {
    unawaited(_bindStream());
  }

  Future<void> refresh() async {
    final userId = auth.currentUserId;
    if (userId == null) return;
    isBusy = true;
    notifyListeners();
    try {
      todos = await repo.fetchAll(userId);
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> add(String title, String? notes) async {
    final userId = auth.currentUserId;
    if (userId == null) return;
    await repo.add(userId, title, notes);
  }

  Future<void> update(Todo todo) async {
    await repo.update(todo);
  }

  Future<void> delete(String id) async {
    await repo.delete(id);
  }

  Future<void> toggle(String id) async {
    await repo.toggle(id);
  }

  Future<Todo?> byId(String id) async {
    for (final todo in todos) {
      if (todo.id == id) return todo;
    }
    return await repo.getById(id);
  }

  @override
  void dispose() {
    auth.removeListener(_handleAuthChange);
    _sub?.cancel();
    super.dispose();
  }
}
