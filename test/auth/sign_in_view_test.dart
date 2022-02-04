import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sophia_hub/provider/auth.dart';
import 'package:sophia_hub/provider/share_pref.dart';
import 'package:sophia_hub/view/page/auth/login.dart';

//TODO adding mock firestore
main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late SharedPref sharedPref;
  late MockFirebaseStorage firebaseStorage;

  late Widget testView;
  setUpAll(() async {
    final user1 = MockUser(
      email: "u1@gmail.com",
    );
    mockFirebaseAuth = MockFirebaseAuth(mockUser: user1, signedIn: false);
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    firebaseStorage = MockFirebaseStorage();

    Map<String, Object> values = <String, Object>{};
    SharedPreferences.setMockInitialValues(values);
    sharedPref = SharedPref();
    await sharedPref.init();

    testView = MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => Auth(
            firebaseAuth: mockFirebaseAuth,
            fireStore: fakeFirebaseFirestore,
            firebaseStorage: firebaseStorage),
        child: Material(child: LoginView()),
      ),
    );
  });

  group("Login In View Form", () {
    testWidgets("UI display", (tester) async {
      await tester.pumpWidget(testView);
      await tester.idle();

      Finder emailField = find.text('Email');
      Finder pwdField = find.text('Mật khẩu');

      expect(emailField, findsOneWidget);
      expect(pwdField, findsOneWidget);
    });

    testWidgets("Type In Email and Password", (tester) async {
      await tester.pumpWidget(testView);
      await tester.idle();

      expect(find.text("Email"), findsOneWidget);
      await tester.pump();
      await tester.enterText(find.byTooltip("Login email form field"), 'u1@gmail.com');
      expect(find.text('u1@gmail.com'), findsOneWidget);

      expect(find.text("Mật khẩu"), findsOneWidget);
      await tester.pump();
      await tester.enterText(find.byTooltip("Login password form field"), '12345678');
      expect(find.text('12345678'), findsOneWidget);
    });
  });
}
