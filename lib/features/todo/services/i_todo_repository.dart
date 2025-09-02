import '../models/todo.dart';

abstract class ITodoRepository {
  Stream<List<Todo>> watchTodos(String userId);
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> toggleDone(String todoId);
  Future<void> deleteTodo(String todoId);
}
