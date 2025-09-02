import 'package:flutter_test/flutter_test.dart';
import 'package:efrei_todo/main.dart' as app;

void main() {
  testWidgets('App starts and shows sign-in', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Connexion'), findsOneWidget);
  });
}
