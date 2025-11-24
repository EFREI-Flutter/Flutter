import 'package:efrei_todo/features/auth/store/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../stores/todo_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Rafraîchit la liste au démarrage de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TodoStore>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();
    final store = context.watch<TodoStore>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes tâches'),
        actions: [
          IconButton(
            tooltip: 'Réglages',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            tooltip: 'Se déconnecter',
            onPressed: () async {
              await auth.signOut();
              if (!mounted) return;
              context.go('/signin');
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: store.isBusy
              ? const Center(child: CircularProgressIndicator())
              : store.todos.isEmpty
                  ? _EmptyState(onCreatePressed: () => context.go('/todo/new'))
                  : RefreshIndicator(
                      onRefresh: () async => store.refresh(),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        children: [
                          _HeaderSummary(
                            total: store.todos.length,
                            done: store.todos.where((t) => t.isDone).length,
                          ),
                          const SizedBox(height: 12),
                          ...store.todos.map(
                            (t) => Dismissible(
                              key: ValueKey(t.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) => store.delete(t.id),
                              child: Card(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => context.go('/todo/${t.id}'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: t.isDone,
                                        onChanged: (_) => store.toggle(t.id),
                                      ),
                                      title: Text(
                                        t.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          decoration: t.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: t.isDone
                                              ? Colors.grey.shade600
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                      subtitle: (t.notes == null ||
                                              t.notes!.trim().isEmpty)
                                          ? null
                                          : Text(
                                              t.notes!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                      trailing: const Icon(
                                        Icons.chevron_right_rounded,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
        child: FloatingActionButton(
          onPressed: () => context.go('/todo/new'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const _EmptyState({required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 72,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune tâche pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crée ta première tâche pour commencer à organiser ta journée.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onCreatePressed,
              icon: const Icon(Icons.add),
              label: const Text('Créer une tâche'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSummary extends StatelessWidget {
  final int total;
  final int done;

  const _HeaderSummary({
    required this.total,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final remaining = total - done;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checklist_rounded,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$remaining tâche${remaining > 1 ? 's' : ''} à faire',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$done terminée${done > 1 ? 's' : ''} • $total au total',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
