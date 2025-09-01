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
    return Todo(
      id: d.id,
      uid: m['uid'] as String,
      title: m['title'] as String,
      done: (m['done'] as bool?) ?? false,
      createdAt: (m['createdAt'] as Timestamp).toDate(),
      dueAt: (m['dueAt'] as Timestamp?)?.toDate(),
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
