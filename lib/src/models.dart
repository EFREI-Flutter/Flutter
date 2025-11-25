import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String userId;
  final String title;
  final String? notes;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;
  Todo({
    required this.id,
    required this.userId,
    required this.title,
    this.notes,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });
  Todo copyWith({String? title, String? notes, bool? isDone, DateTime? updatedAt}) {
    return Todo(
      id: id,
      userId: userId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  factory Todo.fromMap(Map<String, dynamic> m) {
    return Todo(
      id: m['id'] as String,
      userId: m['userId'] as String,
      title: m['title'] as String,
      notes: m['notes'] as String?,
      isDone: m['isDone'] as bool,
      createdAt: DateTime.parse(m['createdAt'] as String),
      updatedAt: DateTime.parse(m['updatedAt'] as String),
    );
  }
  factory Todo.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final created = data['createdAt'];
    final updated = data['updatedAt'];
    DateTime parseTs(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    return Todo(
      id: doc.id,
      userId: (data['uid'] ?? data['userId'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      notes: data['notes'] as String?,
      isDone: (data['done'] ?? data['isDone'] ?? false) as bool,
      createdAt: parseTs(created),
      updatedAt: parseTs(updated ?? created),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'notes': notes,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  Map<String, dynamic> toFirestoreMap() {
    return {
      'uid': userId,
      'title': title,
      'notes': notes,
      'done': isDone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}