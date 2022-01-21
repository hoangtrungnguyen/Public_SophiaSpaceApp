// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';

Widget loginEmailField = TextFormField(
  decoration: InputDecoration(label: Text("Email")),
);

void main() {
  setUpAll(() async {});

  testWidgets('AuthScreen', (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    // Build our app and trigger a frame.
    await tester.pumpWidget(AuthPage());
    await tester.enterText(
        find.byWidget(loginEmailField), "nguyencua1810@gmail.com");
    // Tap the '+' icon and trigger a frame.
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('nguyencua1810@gmail.com'), findsWidgets);
  });
}
