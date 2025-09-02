class Todo {
  final String id;
  final String userId;
  final String title;
  final String? notes;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Todo({
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
  static Todo draft({required String userId, required String title, String? notes}) {
    final now = DateTime.now();
    return Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
      title: title,
      notes: notes,
      isDone: false,
      createdAt: now,
      updatedAt: now,
    );
  }
}
