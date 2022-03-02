import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sophia_hub/main.dart' as app;

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Note Views', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final startButton = find.text("Bắt đầu").first;

      tester.tap(startButton);

      final emailField = find.byTooltip("Email Field").first;
      final pwdField = find.byTooltip("Password Field").first;
      final loginButton = find.byType(ElevatedButton).first;

      tester.enterText(emailField, "c@gmail.com");
      tester.enterText(pwdField, "12345678");
      tester.pumpAndSettle();

      tester.tap(loginButton);
      tester.pumpAndSettle();

      await tester.dragFrom(Offset(0, 200), Offset(0, -200));
      await tester.dragFrom(Offset(0, 200), Offset(0, -200));
      await tester.dragFrom(Offset(0, 200), Offset(0, -200));
      await tester.dragFrom(Offset(0, 200), Offset(0, -200));
      await tester.dragFrom(Offset(0, 200), Offset(0, -200));

      await Future.delayed(Duration(seconds: 10));
    });
  });
}
