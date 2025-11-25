import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../stores/todo_store.dart';

class TodoFormScreen extends StatefulWidget {
  final String? id;

  const TodoFormScreen({this.id, super.key});

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final title = TextEditingController();
  final notes = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Todo? current;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.id != null) {
        current = await context.read<TodoStore>().byId(widget.id!);
        if (current != null) {
          title.text = current!.title;
          notes.text = current!.notes ?? '';
        }
      }
      if (!mounted) return;
      setState(() => loading = false);
    });
  }

  @override
  void dispose() {
    title.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;

    final store = context.read<TodoStore>();
    final trimmedNotes = notes.text.trim().isEmpty ? null : notes.text.trim();

    if (current == null) {
      await store.add(title.text.trim(), trimmedNotes);
    } else {
      await store.update(
        current!.copyWith(
          title: title.text.trim(),
          notes: trimmedNotes,
        ),
      );
    }

    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _delete() async {
    if (current == null) return;
    final store = context.read<TodoStore>();
    await store.delete(current!.id);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = current != null;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 1,
            onDestinationSelected: (i) {
              if (i == 0) context.go('/home');
              if (i == 1) context.go('/todo/new');
              if (i == 2) context.go('/settings');
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Accueil'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle),
                label: Text('Ajouter'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Réglages'),
              ),
            ],
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title:
                    Text(isEditing ? 'Modifier la tâche' : 'Nouvelle tâche'),
              ),
              body: loading
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: title,
                                        decoration: const InputDecoration(
                                          labelText: 'Titre',
                                          prefixIcon: Icon(Icons.title),
                                        ),
                                        validator: (v) => v != null &&
                                                v.trim().isNotEmpty
                                            ? null
                                            : 'Titre obligatoire',
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 14),
                                            child: Icon(
                                              Icons.notes_outlined,
                                              size: 22,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TextFormField(
                                              controller: notes,
                                              minLines: 3,
                                              maxLines: 6,
                                              decoration:
                                                  const InputDecoration(
                                                labelText: 'Notes',
                                                alignLabelWithHint: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _save,
                                              child:
                                                  const Text('Enregistrer'),
                                            ),
                                          ),
                                          if (isEditing) ...[
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: _delete,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child:
                                                    const Text('Supprimer'),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
