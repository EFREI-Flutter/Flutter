// demo page, pas utile pour l'app finale

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/todo.dart';
import '../../core/repo/firestore_todo_repo.dart';

class TodosDemoPage extends StatefulWidget {
  const TodosDemoPage({super.key});
  @override
  State<TodosDemoPage> createState() => _TodosDemoPageState();
}

class _TodosDemoPageState extends State<TodosDemoPage> {
  final _auth = FirebaseAuth.instance;
  final _repo = FirestoreTodoRepo(FirebaseFirestore.instance);
  final _controller = TextEditingController();
  String? _uid;

  @override
  void initState() {
    super.initState();
    _signInTestUser();
  }

  Future<void> _signInTestUser() async {
    const email = 'test@efrei.fr';
    const pass  = 'Passw0rd123!';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      } else if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        final uniqueEmail = 'test+${DateTime.now().microsecondsSinceEpoch}@efrei.fr';
        await _auth.createUserWithEmailAndPassword(email: uniqueEmail, password: pass);
      } else {
        rethrow;
      }
    }
    setState(() => _uid = _auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Todos Demo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nouvelle tâche…',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Ajouter')),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: _repo.watchByUid(_uid!),
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text('Erreur: ${snap.error}'));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final todos = snap.data!;
                if (todos.isEmpty) return const Center(child: Text('Aucune tâche'));
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, i) {
                    final t = todos[i];
                    return Dismissible(
                      key: ValueKey(t.id),
                      background: Container(color: Colors.redAccent),
                      onDismissed: (_) => _repo.delete(t.id),
                      child: ListTile(
                        title: Text(
                          t.title,
                          style: TextStyle(
                            decoration: t.done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: Switch(
                          value: t.done,
                          onChanged: (v) => _repo.toggleDone(id: t.id, done: v),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    await _repo.add(Todo(
      id: '',
      uid: _uid!,
      title: title,
      done: false,
      createdAt: DateTime.now(),
    ));
    _controller.clear();
  }
}
