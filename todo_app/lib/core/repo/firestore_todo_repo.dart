import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';
import 'i_todo_repo.dart';

class FirestoreTodoRepo implements ITodoRepo {
  final FirebaseFirestore _fs;
  FirestoreTodoRepo(this._fs);

  CollectionReference<Map<String, dynamic>> get _col => _fs.collection('todos');

  @override
  Stream<List<Todo>> watchByUid(String uid) => _col
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Todo.fromDoc).toList());

  @override
  Future<String> add(Todo t) async {
    final ref = await _col.add({
      'uid': t.uid,
      'title': t.title,
      'done': t.done,
      'createdAt': FieldValue.serverTimestamp(),
      if (t.dueAt != null) 'dueAt': Timestamp.fromDate(t.dueAt!),
    });
    return ref.id;
  }

  @override
  Future<void> toggleDone({required String id, required bool done}) =>
      _col.doc(id).update({'done': done});

  @override
  Future<void> delete(String id) => _col.doc(id).delete();
}
