import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/main.dart';

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  setUpAll(() async {
    final user1 = MockUser(email: "u1@gmail.com");
    mockFirebaseAuth = MockFirebaseAuth(mockUser: user1);
  });

  group("Login In View Form", () {
    testWidgets("UI display", (tester) async {
      await tester.pumpWidget(MyApp());
      await tester.idle();

      Finder emailField = find.text('Email');
      Finder pwdField = find.text('Mật khẩu');

      expect(emailField, findsOneWidget);
      expect(pwdField, findsOneWidget);
    });

    testWidgets("Type In Email and Password", (tester) async {
      await tester.pumpWidget(MyApp());
      await tester.idle();

      expect(find.text("Email"), findsOneWidget);
      await tester.pump();
      await tester.enterText(
          find.byTooltip("Login email form field"), 'u1@gmail.com');
      expect(find.text('u1@gmail.com'), findsOneWidget);

      expect(find.text("Mật khẩu"), findsOneWidget);
      await tester.pump();
      await tester.enterText(
          find.byTooltip("Login password form field"), '12345678');
      expect(find.text('12345678'), findsOneWidget);
    });

    testWidgets("Tap `Đăng ký` button then move to register view",
        (tester) async {
      await tester.pumpWidget(MyApp());
      await tester.idle();

      await tester.tap(find.text("Đăng ký"));
      await tester.pumpAndSettle();
      expect(find.byTooltip("Login email form field"), findsNothing);
    });

    testWidgets("Tap `Đăng nhập` button", (tester) async {
      await tester.pumpWidget(MyApp());
      await tester.idle();

      await tester.pump();
      await tester.enterText(
          find.byTooltip("Login email form field"), 'u1@gmail.com');
      expect(find.text('u1@gmail.com'), findsOneWidget);

      await tester.enterText(
          find.byTooltip("Login password form field"), '12345678');
      expect(find.text('12345678'), findsOneWidget);
    });
  });
}
