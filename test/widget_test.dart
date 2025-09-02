import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:efrei_todo/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('App starts and shows sign-in', (tester) async {
    SharedPreferences.setMockInitialValues({});
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Connexion'), findsOneWidget);
  });
}
