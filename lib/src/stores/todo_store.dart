import 'package:flutter/foundation.dart';
import '../models.dart';
import '../services/interfaces/todo_repository.dart';
import 'auth_store.dart';

class TodoStore extends ChangeNotifier {
  final TodoRepository repo;
  final AuthStore auth;
  List<Todo> todos = [];
  bool isBusy = false;
  TodoStore(this.repo, this.auth);
  Future<void> init() async {
    if (auth.currentUserEmail != null) {
      await refresh();
    }
  }
  Future<void> refresh() async {
    if (auth.currentUserEmail == null) return;
    isBusy = true;
    notifyListeners();
    try {
      todos = await repo.fetchAll(auth.currentUserEmail!);
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
  Future<void> add(String title, String? notes) async {
    if (auth.currentUserEmail == null) return;
    await repo.add(auth.currentUserEmail!, title, notes);
    await refresh();
  }
  Future<void> update(Todo todo) async {
    await repo.update(todo);
    await refresh();
  }
  Future<void> delete(String id) async {
    await repo.delete(id);
    await refresh();
  }
  Future<void> toggle(String id) async {
    await repo.toggle(id);
    await refresh();
  }
  Future<Todo?> byId(String id) async {
    return await repo.getById(id);
  }
}
