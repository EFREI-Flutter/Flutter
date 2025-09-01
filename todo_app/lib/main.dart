import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// ---------- MODELE / REPO MINIMAUX POUR TEST ----------
class Todo {
  final String id, uid, title;
  final bool done;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.uid,
    required this.title,
    required this.done,
    required this.createdAt,
  });

  factory Todo.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data()!;
    return Todo(
      id: d.id,
      uid: m['uid'] as String,
      title: m['title'] as String,
      done: (m['done'] as bool?) ?? false,
      createdAt: (m['createdAt'] as Timestamp).toDate(),
    );
  }
}

class FirestoreTodoRepo {
  final FirebaseFirestore _fs;
  FirestoreTodoRepo(this._fs);
  CollectionReference<Map<String, dynamic>> get _col => _fs.collection('todos');

  Stream<List<Todo>> watchByUid(String uid) => _col
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Todo.fromDoc).toList());

  Future<String> add({required String uid, required String title}) async {
    final ref = await _col.add({
      'uid': uid,
      'title': title,
      'done': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> toggleDone(String id, bool done) => _col.doc(id).update({'done': done});
  Future<void> delete(String id) => _col.doc(id).delete();
}
// -------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmokeTestPage(),
    );
  }
}

class SmokeTestPage extends StatefulWidget {
  const SmokeTestPage({super.key});
  @override
  State<SmokeTestPage> createState() => _SmokeTestPageState();
}

class _SmokeTestPageState extends State<SmokeTestPage> {
  final _auth = FirebaseAuth.instance;
  final _fs = FirebaseFirestore.instance;
  late final FirestoreTodoRepo _repo = FirestoreTodoRepo(_fs);

  String? _uid;
  String? _error;
  bool _busy = false;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signInTestUser();
  }

  // ---------- METHODE MODIFIEE ----------
  Future<void> _signInTestUser() async {
    setState(() { _busy = true; _error = null; });

    try {
      const email = 'test@efrei.fr';  // ⚠️ change si tu veux un autre mail
      const pass  = 'Passw0rd123!';

      try {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Crée l'utilisateur si absent
          await _auth.createUserWithEmailAndPassword(email: email, password: pass);
        } else if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
          // Utilisateur existe mais mauvais mot de passe → crée un nouvel utilisateur unique
          final uniqueEmail = 'test+${DateTime.now().microsecondsSinceEpoch}@efrei.fr';
          await _auth.createUserWithEmailAndPassword(email: uniqueEmail, password: pass);
        } else {
          rethrow;
        }
      }

      setState(() => _uid = _auth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = 'Auth error: ${e.code}');
    } catch (e) {
      setState(() => _error = 'Unknown error: $e');
    } finally {
      setState(() => _busy = false);
    }
  }
  // --------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_busy) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null && _uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Smoke Test Todos (Firebase)')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _signInTestUser,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    if (_uid == null) {
      return const Scaffold(body: Center(child: Text('Auth en attente…')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Smoke Test Todos (Firebase)')),
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
                if (snap.hasError) {
                  return Center(child: Text('Firestore error: ${snap.error}'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
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
                        subtitle: Text(t.createdAt.toLocal().toString()),
                        trailing: Switch(
                          value: t.done,
                          onChanged: (v) => _repo.toggleDone(t.id, v),
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
    await _repo.add(uid: _uid!, title: title);
    _controller.clear();
  }
}
