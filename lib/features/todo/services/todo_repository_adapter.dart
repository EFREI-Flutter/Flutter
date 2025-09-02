import 'dart:async';
import 'package:collection/collection.dart';
import '../../../src/services/interfaces/todo_repository.dart' as c;
import '../../../src/models.dart' as cmodel;
import '../models/todo.dart';
import 'i_todo_repository.dart';

class TodoRepositoryAdapter implements ITodoRepository {
  final c.TodoRepository _inner;
  final _streams = <String, StreamController<List<Todo>>>{};
  TodoRepositoryAdapter(this._inner);

  @override
  Stream<List<Todo>> watchTodos(String userId) {
    _streams[userId] ??= StreamController<List<Todo>>.broadcast();
    _refresh(userId);
    return _streams[userId]!.stream;
  }

  Future<void> _refresh(String userId) async {
    final list = await _inner.fetchAll(userId);
    final mapped = list.map((t) => Todo(
      id: t.id,
      userId: t.userEmail,
      title: t.title,
      notes: t.notes,
      isDone: t.isDone,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
    )).toList();
    _streams[userId]?.add(List.unmodifiable(mapped));
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await _inner.add(todo.userId, todo.title, todo.notes);
    await _refresh(todo.userId);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final ctodo = cmodel.Todo(
      id: todo.id,
      userEmail: todo.userId,
      title: todo.title,
      notes: todo.notes,
      isDone: todo.isDone,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
    await _inner.update(ctodo);
    await _refresh(todo.userId);
  }

  @override
  Future<void> toggleTodo(String todoId) async {
    await _inner.toggle(todoId);
    // Need userId to refresh; try to infer by scanning all streams
    for (final entry in _streams.entries) {
      await _refresh(entry.key);
    }
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _inner.delete(todoId);
    for (final entry in _streams.entries) {
      await _refresh(entry.key);
    }
  }
}
