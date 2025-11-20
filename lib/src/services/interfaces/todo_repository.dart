import 'dart:async';

import '../../models.dart';

abstract class TodoRepository {
  Future<List<Todo>> fetchAll(String userId);
  Stream<List<Todo>> watchAll(String userId);
  Future<void> add(String userId, String title, String? notes);
  Future<void> update(Todo todo);
  Future<void> delete(String id);
  Future<Todo?> getById(String id);
  Future<void> toggle(String id);
}