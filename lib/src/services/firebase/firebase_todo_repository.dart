import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models.dart';
import '../interfaces/todo_repository.dart';

class FirebaseTodoRepository implements TodoRepository {
  CollectionReference<Map<String, dynamic>> get _todos => FirebaseFirestore.instance.collection('todos');

  Query<Map<String, dynamic>> _queryFor(String userId) {
    return _todos.where('uid', isEqualTo: userId).orderBy('createdAt', descending: true);
  }

  @override
  Future<void> add(String userId, String title, String? notes) async {
    final now = Timestamp.now();
    await _todos.add({
      'title': title,
      'notes': notes,
      'done': false,
      'uid': userId,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  @override
  Future<void> delete(String id) async {
    await _todos.doc(id).delete();
  }

  @override
  Future<List<Todo>> fetchAll(String userId) async {
    final snap = await _queryFor(userId).get();
    return snap.docs.map(Todo.fromDoc).toList();
  }

  @override
  Stream<List<Todo>> watchAll(String userId) {
    return _queryFor(userId).snapshots().map((event) => event.docs.map(Todo.fromDoc).toList());
  }

  @override
  Future<Todo?> getById(String id) async {
    final doc = await _todos.doc(id).get();
    if (!doc.exists) return null;
    return Todo.fromDoc(doc);
  }

  @override
  Future<void> toggle(String id) async {
    final doc = await _todos.doc(id).get();
    if (!doc.exists) return;
    final current = doc.data()?['done'] as bool? ?? false;
    await _todos.doc(id).update({'done': !current, 'updatedAt': Timestamp.now()});
  }

  @override
  Future<void> update(Todo todo) async {
    await _todos.doc(todo.id).update({
      'title': todo.title,
      'notes': todo.notes,
      'done': todo.isDone,
      'updatedAt': Timestamp.now(),
    });
  }
}