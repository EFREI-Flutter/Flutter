import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/store/auth_store.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override State<SignInPage> createState() => _SignInPageState();
}
class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController(text: 'demo@efrei.fr');
  final _pass = TextEditingController(text: 'demo1234');

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => auth.signIn(_email.text, _pass.text),
            child: const Text('Sign in (fake)'),
          ),
        ]),
      ),
    );
  }
}
