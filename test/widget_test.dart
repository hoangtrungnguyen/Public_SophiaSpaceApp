// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sophia_hub/main.dart';

Widget loginEmailField = TextFormField(
      decoration: InputDecoration(label: Text("Email")),
 );

void main() {
  testWidgets('AuthScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    await tester.enterText(find.byWidget(loginEmailField), "nguyencua1810@gmail.com");
    // Tap the '+' icon and trigger a frame.
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('nguyencua1810@gmail.com'), findsWidgets);
  });
}
