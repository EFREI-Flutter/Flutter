import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/store/auth_store.dart';
import '../store/todo_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoStore>();
    final auth = context.read<AuthStore>();

    Widget body;

    // Loader
    if (todos.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    }
    // Erreur éventuelle
    else if (todos.error != null) {
      body = Center(
        child: Text(
          'Erreur : ${todos.error}',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    // Liste vide
    else if (todos.items.isEmpty) {
      body = const Center(
        child: Text(
          "Aucune tâche.\nAppuie sur + pour en ajouter.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    // Liste avec des todos
    else {
      body = ListView.builder(
        itemCount: todos.items.length,
        itemBuilder: (_, i) {
          final t = todos.items[i];
          return Dismissible(
            key: ValueKey(t.id),
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => todos.remove(t.id),
            child: ListTile(
              title: Text(
                t.title,
                style: TextStyle(
                  decoration:
                      t.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: t.notes == null ? null : Text(t.notes!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cocher/Décocher
                  Checkbox(
                    value: t.isDone,
                    onChanged: (_) => todos.toggle(t.id),
                  ),
                  // Icône suppression
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => todos.remove(t.id),
                  ),
                ],
              ),
              // Suppression aussi par appui long
              onLongPress: () => todos.remove(t.id),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes todos'),
        actions: [
          IconButton(
            onPressed: auth.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => todos.add('Nouvelle tâche'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
