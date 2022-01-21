import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sophia_hub/main.dart' as app;

Future<void> main() async {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;

  testWidgets('verify text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    app.main();

    // Trace the timeline of the following operation. The timeline result will
    // be written to `build/integration_response_data.json` with the key
    // `timeline`.
    await binding.traceAction(() async {
      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify that screen have text.
      expect(
        find.byType(TextFormField),
        findsNWidgets(2),
      );
      await Future.delayed(Duration(seconds: 3));

      expect(find.text("Email"), findsOneWidget);
      // await tester.pump();
      await tester.enterText(
          find.byTooltip("Login email form field"), 'u1@gmail.com');
      expect(find.text('u1@gmail.com'), findsOneWidget);

      await Future.delayed(Duration(seconds: 3));
      expect(find.text("Mật khẩu"), findsOneWidget);
      await tester.pump();
      await tester.enterText(
          find.byTooltip("Login password form field"), '12345678');
      await Future.delayed(Duration(seconds: 3));
      expect(find.text('12345678'), findsOneWidget);
    });
  });
}
