import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id, uid, title;
  final bool done;
  final DateTime createdAt;
  final DateTime? dueAt;

  const Todo({
    required this.id,
    required this.uid,
    required this.title,
    required this.done,
    required this.createdAt,
    this.dueAt,
  });

  factory Todo.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data()!;
    final ts = m['createdAt'];
    final due = m['dueAt'];

    return Todo(
      id: d.id,
      uid: m['uid'] as String,
      title: m['title'] as String,
      done: (m['done'] as bool?) ?? false,
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
      dueAt: due is Timestamp ? due.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'title': title,
    'done': done,
    'createdAt': Timestamp.fromDate(createdAt),
    if (dueAt != null) 'dueAt': Timestamp.fromDate(dueAt!),
  };
}
