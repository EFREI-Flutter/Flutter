// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../lib/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App démarre et affiche Todo OU Connexion', (tester) async {
    SharedPreferences.setMockInitialValues({});

    app.main();
    await tester.pumpAndSettle();

    //  Todo
    final todoInput = find.text('Nouvelle tâche...');
    final addButton = find.text('Ajouter');

    // Connexion
    final emailField = find.widgetWithText(TextField, 'Email');
    final pwdField   = find.widgetWithText(TextField, 'Mot de passe');

    final isTodo  = todoInput.evaluate().isNotEmpty && addButton.evaluate().isNotEmpty;
    final isLogin = emailField.evaluate().isNotEmpty && pwdField.evaluate().isNotEmpty;

    expect(isTodo || isLogin, isTrue, reason: 'Ni Todo ni Connexion détecté');

    if (isTodo) {
      expect(todoInput, findsOneWidget);
      expect(addButton, findsOneWidget);
    }
    if (isLogin) {
      expect(emailField, findsOneWidget);
      expect(pwdField, findsOneWidget);
    }
  });
}
