import 'package:efrei_todo/features/auth/store/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _submitting = false;

  Future<void> _submit(AuthStore auth) async {
    if (!mounted || _submitting) return;
    setState(() => _submitting = true);
    try {
      if (!formKey.currentState!.validate()) return;
      await auth.signUp(email.text.trim(), password.text);
      if (!mounted) return;
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException(signUp): ${e.code} - ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? e.code)),
      );
    } catch (e, stack) {
      debugPrint('Unexpected sign-up error: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email deja utilise')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v != null && v.contains('@') ? null : 'Email invalide',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (v) => v != null && v.length >= 6 ? null : '6 caracteres minimum',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirm,
                decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
                obscureText: true,
                validator: (v) => v == password.text ? null : 'Les mots de passe ne correspondent pas',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (auth.isLoading || _submitting) ? null : () => _submit(auth),
                  child: auth.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Creer le compte'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


