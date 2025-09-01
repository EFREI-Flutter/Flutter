import 'package:flutter/foundation.dart';
import '../models.dart';
import '../services/services.dart';
import 'auth_store.dart';

class TodoStore extends ChangeNotifier {
  final LocalTodoRepository _repo = LocalTodoRepository();
  final AuthStore auth;
  List<Todo> todos = [];
  bool isBusy = false;
  TodoStore(this.auth);
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
      todos = await _repo.fetchAll(auth.currentUserEmail!);
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
  Future<void> add(String title, String? notes) async {
    if (auth.currentUserEmail == null) return;
    await _repo.add(auth.currentUserEmail!, title, notes);
    await refresh();
  }
  Future<void> update(Todo todo) async {
    await _repo.update(todo);
    await refresh();
  }
  Future<void> delete(String id) async {
    await _repo.delete(id);
    await refresh();
  }
  Future<void> toggle(String id) async {
    await _repo.toggle(id);
    await refresh();
  }
  Future<Todo?> byId(String id) async {
    return await _repo.getById(id);
  }
}
