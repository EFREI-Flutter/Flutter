import 'package:efrei_todo/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('App starts and shows todo home', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Mes tâches'), findsOneWidget);
  });
}
