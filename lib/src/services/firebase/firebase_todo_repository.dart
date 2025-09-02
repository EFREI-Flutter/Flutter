import '../interfaces/todo_repository.dart';
import '../../models.dart';

class FirebaseTodoRepository implements TodoRepository {
  @override
  Future<void> add(String userEmail, String title, String? notes) async {
    throw UnimplementedError();
  }
  @override
  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
  @override
  Future<List<Todo>> fetchAll(String userEmail) async {
    throw UnimplementedError();
  }
  @override
  Future<Todo?> getById(String id) async {
    throw UnimplementedError();
  }
  @override
  Future<void> toggle(String id) async {
    throw UnimplementedError();
  }
  @override
  Future<void> update(Todo todo) async {
    throw UnimplementedError();
  }
}
