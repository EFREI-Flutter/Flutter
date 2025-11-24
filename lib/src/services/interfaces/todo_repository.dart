import '../../models.dart';

abstract class TodoRepository {
  Future<List<Todo>> fetchAll(String userEmail);
  Future<void> add(String userEmail, String title, String? notes);
  Future<void> update(Todo todo);
  Future<void> delete(String id);
  Future<Todo?> getById(String id);
  Future<void> toggle(String id);
}
