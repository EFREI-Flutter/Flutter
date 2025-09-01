import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../stores/auth_store.dart';
import '../stores/todo_store.dart';
import '../models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TodoStore>().refresh());
  }
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();
    final store = context.watch<TodoStore>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes tâches'),
        actions: [
          IconButton(onPressed: () => context.go('/settings'), icon: const Icon(Icons.settings)),
          IconButton(onPressed: () async { await auth.signOut(); if (context.mounted) context.go('/signin'); }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: store.isBusy ? const Center(child: CircularProgressIndicator()) : store.todos.isEmpty ? const _Empty() : ListView.separated(
        itemCount: store.todos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final t = store.todos[index];
          return Dismissible(
            key: Key(t.id),
            background: Container(color: Colors.red),
            onDismissed: (_) => store.delete(t.id),
            child: ListTile(
              title: Text(t.title, style: TextStyle(decoration: t.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
              subtitle: t.notes == null || t.notes!.isEmpty ? null : Text(t.notes!),
              leading: Checkbox(value: t.isDone, onChanged: (_) => store.toggle(t.id)),
              onTap: () => context.go('/todo/${t.id}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.go('/todo/new'), child: const Icon(Icons.add)),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64),
          const SizedBox(height: 12),
          const Text('Aucune tâche'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => context.go('/todo/new'), child: const Text('Créer une tâche'))
        ],
      ),
    );
  }
}
