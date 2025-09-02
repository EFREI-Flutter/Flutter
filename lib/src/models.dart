class Todo {
  final String id;
  final String userEmail;
  final String title;
  final String? notes;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;
  Todo({
    required this.id,
    required this.userEmail,
    required this.title,
    this.notes,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });
  Todo copyWith({String? title, String? notes, bool? isDone, DateTime? updatedAt}) {
    return Todo(
      id: id,
      userEmail: userEmail,
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
      userEmail: m['userEmail'] as String,
      title: m['title'] as String,
      notes: m['notes'] as String?,
      isDone: m['isDone'] as bool,
      createdAt: DateTime.parse(m['createdAt'] as String),
      updatedAt: DateTime.parse(m['updatedAt'] as String),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'title': title,
      'notes': notes,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
