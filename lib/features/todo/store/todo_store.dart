import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../auth/store/auth_store.dart';
import '../models/todo.dart';
import '../services/i_todo_repository.dart';

class TodoStore extends ChangeNotifier {
  final ITodoRepository _repo;
  final AuthStore _auth;
  StreamSubscription<List<Todo>>? _sub;

  List<Todo> _items = [];
  bool _loading = true;
  Object? _error;

  List<Todo> get items => _items;
  bool get isLoading => _loading;
  Object? get error => _error;

  TodoStore(this._repo, this._auth) {
    _auth.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  void _onAuthChanged() {
    _sub?.cancel();
    _items = [];
    _loading = true;
    _error = null;

    final user = _auth.current;
    if (user == null) {
      _loading = false;
      notifyListeners();
      return;
    }
    _sub = _repo.watchTodos(user.id).listen((data) {
      _items = data;
      _loading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e;
      _loading = false;
      notifyListeners();
    });
  }

  Future<void> add(String title, {String? notes}) async {
    final u = _auth.current; if (u == null) return;
    await _repo.addTodo(Todo.draft(userId: u.id, title: title, notes: notes));
  }

  Future<void> toggle(String id) => _repo.toggleDone(id);
  Future<void> update(Todo t) => _repo.updateTodo(t);
  Future<void> remove(String id) => _repo.deleteTodo(id);

  @override
  void dispose() {
    _sub?.cancel();
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  Todo? byId(String id) {
    for (final t in _items) {
      if (t.id == id) return t;
    }
    return null;
  }
}
