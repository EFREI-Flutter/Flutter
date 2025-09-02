import 'dart:async';
import '../models/todo.dart';
import 'i_todo_repository.dart';

class TodoRepositoryFake implements ITodoRepository {
  final Map<String, List<Todo>> _data = {};
  final Map<String, StreamController<List<Todo>>> _streams = {};

  @override
  Stream<List<Todo>> watchTodos(String userId) {
    _streams[userId] ??= StreamController<List<Todo>>.broadcast();
    _streams[userId]!.add(List.unmodifiable(_data[userId] ?? []));
    return _streams[userId]!.stream;
  }

  void _emit(String userId) {
    _streams[userId]?.add(List.unmodifiable(_data[userId] ?? []));
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final list = _data[todo.userId] ??= [];
    list.add(todo);
    _emit(todo.userId);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final list = _data[todo.userId] ??= [];
    final i = list.indexWhere((t) => t.id == todo.id);
    if (i >= 0) list[i] = todo;
    _emit(todo.userId);
  }

  @override
  Future<void> toggleDone(String todoId) async {
    for (final entry in _data.entries) {
      final i = entry.value.indexWhere((t) => t.id == todoId);
      if (i >= 0) {
        final t = entry.value[i];
        entry.value[i] = t.copyWith(isDone: !t.isDone);
        _emit(entry.key);
        break;
      }
    }
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    for (final entry in _data.entries) {
      entry.value.removeWhere((t) => t.id == todoId);
      _emit(entry.key);
    }
  }
}
