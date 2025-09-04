import '../models/todo.dart';

abstract class ITodoRepo {
  Stream<List<Todo>> watchByUid(String uid);      // tri createdAt desc
  Future<String> add(Todo todo);                   // retourne docId
  Future<void> toggleDone({required String id, required bool done});
  Future<void> delete(String id);
}
