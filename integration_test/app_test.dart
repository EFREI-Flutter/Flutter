import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:efrei_todo/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Sign up and create, toggle, delete todo', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'user@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Mot de passe'), 'abcdef');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text('Identifiants invalides'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Créer un compte'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'user@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Mot de passe'), 'abcdef');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirmer le mot de passe'), 'abcdef');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Créer le compte'));
    await tester.pumpAndSettle();
    expect(find.text('Mes tâches'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Titre'), 'Ma première tâche');
    await tester.enterText(find.widgetWithText(TextFormField, 'Notes'), 'Notes');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Ma première tâche'), findsOneWidget);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.drag(find.text('Ma première tâche'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Aucune tâche'), findsOneWidget);
  });
}
