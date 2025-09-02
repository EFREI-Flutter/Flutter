import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../store/todo_store.dart';

class TodoEditPage extends StatefulWidget {
  final String id;
  const TodoEditPage({super.key, required this.id});

  @override
  State<TodoEditPage> createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  bool _navigatedAway = false;

  void _maybeBounceHome(BuildContext context, TodoStore store) {
    if (_navigatedAway) return;
    if (!store.isLoading && store.byId(widget.id) == null) {
      _navigatedAway = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tâche introuvable')),
        );
        context.go('/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TodoStore>();
    _maybeBounceHome(context, store);

    if (store.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final todo = store.byId(widget.id);
    if (todo == null) {
      // On affiche quelque chose de neutre le temps du redirect post-frame.
      return const Scaffold(
        body: Center(child: SizedBox.shrink()),
      );
    }

    // UI d’édition minimale (Dev C l’améliorera plus tard)
    return Scaffold(
      appBar: AppBar(title: Text('Edit: ${todo.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Édition de "${todo.title}" (stub)'),
      ),
    );
  }
}
