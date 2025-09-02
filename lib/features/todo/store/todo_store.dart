import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../../auth/store/auth_store.dart';
import '../services/i_todo_repository.dart';

class TodoStoreB extends ChangeNotifier {
  final ITodoRepository repo;
  final AuthStoreB auth;
  StreamSubscription<List<Todo>>? _sub;
  List<Todo> items = [];
  bool isBusy = false;

  TodoStoreB(this.repo, this.auth) {
    auth.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  void _onAuthChanged() {
    _sub?.cancel();
    final user = auth.currentUser;
    if (user == null) {
      items = [];
      notifyListeners();
      return;
    }
    _sub = repo.watchTodos(user.id).listen((list) {
      items = list;
      notifyListeners();
    });
  }

  Future<void> add(Todo todo) => repo.addTodo(todo);
  Future<void> update(Todo todo) => repo.updateTodo(todo);
  Future<void> toggle(String id) => repo.toggleTodo(id);
  Future<void> delete(String id) => repo.deleteTodo(id);

  @override
  void dispose() {
    _sub?.cancel();
    auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  Todo? byId(String id) {
    for (final t in items) {
      if (t.id == id) return t;
    }
    return null;
  }
}
