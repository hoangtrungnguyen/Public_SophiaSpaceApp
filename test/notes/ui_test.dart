import 'dart:math';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/auth.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/view/page/home/notes.dart';
import 'package:sophia_hub/view/page/home/notes/single_item_note.dart';

import '../helper/test_helper.dart';

//TODO create UI tests
/// Kiểm tra màn hình noteview
/// Điều kiện:
///   1/ Người dùng đã đăng nhập
///
main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late MockFirebaseStorage firebaseStorage;
  late NotesPublisher publisher;
  late Note note;
  late Widget testView;

  setUpAll(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    fireStore = FakeFirebaseFirestore();
    firebaseStorage = MockFirebaseStorage();
    publisher = NotesPublisher(
        auth: mockFirebaseAuth, fireStore: fireStore, isTesting: true);

    testView = MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('vi', ''),
          Locale('en', '')
        ],
        localeListResolutionCallback: (locales, supportedLocales) {
          for (Locale locale in locales!)
            if (supportedLocales.contains(locale)) return locale;
          return Locale('vi', '');
        },
        locale: Locale('vi', ''),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => publisher),
            ChangeNotifierProvider(
                create: (_) => Auth(
                    fireStore: fireStore,
                    firebaseAuth: mockFirebaseAuth,
                    firebaseStorage: firebaseStorage)),
          ],
          child: Material(
            child: NotesView(),
          ),
        ));
  });

  group("Hiển thị trên tab Note tại trang Home", () {
    setUp(() async {
      await TestHelper.initializeData(publisher);

      //tiêu đề mới nhất
      note = Note(
          title: 'Tiêu đề mới nhất',
          description: "Nội dung  $e",
          emotionPoint: Random().nextInt(10),
          activities: List.from([
            activities[0],
            activities[1],
            activities[2],
          ]));
      await publisher.addNote(note: note);
    });

    tearDown(() async {
      await TestHelper.clearUserData(publisher);
      //renew publisher
      publisher = NotesPublisher(
          auth: mockFirebaseAuth, fireStore: fireStore, isTesting: true);

    });

    testWidgets("Hiển thị dữ liệu", (WidgetTester tester) async {
      await tester.pumpWidget(testView);
      await tester.pumpAndSettle(Duration(seconds: 2));

      //kiểm tra có dữ liệu không
      expect(publisher.notes.length > 0, true);
      //kiểm tra có widget danh sách không
      expect(find.byType(DailyNotes), findsWidgets);

      expect(find.text("Tiêu đề mới nhất"), findsOneWidget);
    });

    testWidgets("Thay đổi hiển thị dữ liệu", (WidgetTester tester) async {
      // await tester.pumpWidget(testView);
      // await tester.pumpAndSettle(Duration(seconds: 1));
      //
      // publisher.updateNote(publisher.notes[0]..title = 'Tiêu đề được thay đổi');
      // await tester.pumpAndSettle();
      //
      // //thay đổi thời gian
      // publisher.updateNote(publisher.notes[0]
      //   ..timeCreated = DateTime.now().subtract(Duration(days: 16)));
      // await tester.pumpAndSettle();
      // //Lướt đến hết màn hình
      // await tester.scrollUntilVisible(find.text('Tiêu đề được thay đổi'), 1000);
      // await tester.pumpAndSettle();
      // //kiểm tra số lượng phần từ có đầy đủ không
      // expect(publisher.notes.length, 11);
      //
      // expect(find.text('Tiêu đề được thay đổi'), findsOneWidget);
    });
  });

}
