import 'dart:async';
import '../../../src/services/interfaces/todo_repository.dart' as c;
import '../../../src/models.dart' as cmodel;
import '../models/todo.dart';
import 'i_todo_repository.dart';

class TodoRepositoryAdapter implements ITodoRepository {
  final c.TodoRepository _inner;
  TodoRepositoryAdapter(this._inner);

  Todo _map(cmodel.Todo t) {
    return Todo(
      id: t.id,
      userId: t.userId,
      title: t.title,
      notes: t.notes,
      isDone: t.isDone,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
    );
  }

  @override
  Stream<List<Todo>> watchTodos(String userId) {
    return _inner.watchAll(userId).map((list) => list.map(_map).toList());
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await _inner.add(todo.userId, todo.title, todo.notes);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final ctodo = cmodel.Todo(
      id: todo.id,
      userId: todo.userId,
      title: todo.title,
      notes: todo.notes,
      isDone: todo.isDone,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
    await _inner.update(ctodo);
  }

  @override
  Future<void> toggleTodo(String todoId) async {
    await _inner.toggle(todoId);
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _inner.delete(todoId);
  }
}