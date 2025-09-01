import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../stores/todo_store.dart';
import '../models.dart';

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
    Future.microtask(() async {
      if (widget.id != null) {
        current = await context.read<TodoStore>().byId(widget.id!);
        if (current != null) {
          title.text = current!.title;
          notes.text = current!.notes ?? '';
        }
      }
      setState(() { loading = false; });
    });
  }
  @override
  Widget build(BuildContext context) {
    final store = context.watch<TodoStore>();
    return Scaffold(
      appBar: AppBar(title: Text(current == null ? 'Nouvelle tâche' : 'Modifier la tâche')),
      body: loading ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Titre obligatoire',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notes,
                decoration: const InputDecoration(labelText: 'Notes'),
                minLines: 2,
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        if (current == null) {
                          await store.add(title.text.trim(), notes.text.trim().isEmpty ? null : notes.text.trim());
                        } else {
                          await store.update(current!.copyWith(title: title.text.trim(), notes: notes.text.trim().isEmpty ? null : notes.text.trim()));
                        }
                        if (mounted) context.go('/home');
                      },
                      child: const Text('Enregistrer'),
                    ),
                  ),
                  if (current != null) const SizedBox(width: 12),
                  if (current != null) Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await store.delete(current!.id);
                        if (mounted) context.go('/home');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      child: const Text('Supprimer'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
