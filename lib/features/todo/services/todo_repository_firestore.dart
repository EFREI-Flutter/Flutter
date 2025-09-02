import '../models/todo.dart';
import 'i_todo_repository.dart';

class TodoRepositoryFirestore implements ITodoRepository {
  @override
  Stream<List<Todo>> watchTodos(String userId) => throw UnimplementedError();

  @override
  Future<void> addTodo(Todo todo) => throw UnimplementedError();

  @override
  Future<void> updateTodo(Todo todo) => throw UnimplementedError();

  @override
  Future<void> toggleDone(String todoId) => throw UnimplementedError();

  @override
  Future<void> deleteTodo(String todoId) => throw UnimplementedError();
}
