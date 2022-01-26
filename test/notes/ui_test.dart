import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/view/page/home/notes.dart';
import 'package:sophia_hub/view/page/home_container.dart';
import 'package:sophia_hub/view/page/note/create_note_page.dart';
import 'package:sophia_hub/view/page/note/note_detail.dart';

main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late NotesProvider provider;
  late Note note;

  setUpAll(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    fireStore = FakeFirebaseFirestore();
  });

  setUp(() async {
    provider = NotesProvider(
        auth: mockFirebaseAuth,
        fireStore: fireStore,
        isTesting: true);

    await Future.forEach(List<int>.generate(10, (i) => i + 1), (int e) async {
      Note note = Note(
          title: 'Tiêu đề $e',
          description: "Nội dung  $e",
          emotionPoint: Random().nextInt(10),
          activities: LinkedHashSet.from([
            activities[0],
            activities[1],
            activities[2],
          ]));
      note
        ..timeCreated =
            DateTime.now().subtract(Duration(days: Random().nextInt(15)));
      await provider.addNote(note: note);
    });

    //tiêu đề mới nhất
    note = Note(
        title: 'Tiêu đề mới nhất',
        description: "Nội dung  $e",
        emotionPoint: Random().nextInt(10),
        activities: LinkedHashSet.from([
          activities[0],
          activities[1],
          activities[2],
        ]));
    await provider.addNote(note: note);
  });

  tearDown(() async {
    QuerySnapshot snapshots = await provider.notesRef.get();
    await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
      await doc.reference.delete();
    });

    provider = NotesProvider(
        auth: mockFirebaseAuth,
        fireStore: fireStore,
        isTesting: true);
  });

  group("Hiển thị", () {
    testWidgets("Hiển thị dữ liệu", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ChangeNotifierProvider(
        create: (_) => provider,
        child: NotesView(),
      )));
      await tester.pumpAndSettle(Duration(seconds: 2));

      //kiểm tra có dữ liệu không
      expect(provider.notes.length > 0, true);
      //kiểm tra có widget danh sách không
      expect(find.byType(DailyNotes), findsWidgets);

      expect(find.text("Tiêu đề mới nhất"), findsOneWidget);
    });

    testWidgets("Thay đổi hiển thị dữ liệu", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ChangeNotifierProvider(
        create: (_) => provider,
        child: NotesView(),
      )));
      await tester.pumpAndSettle(Duration(seconds: 1));

      provider.updateNote(provider.notes[0]..title = 'Tiêu đề được thay đổi');
      await tester.pumpAndSettle();

      //thay đổi thời gian
      provider.updateNote(provider.notes[0]
        ..timeCreated = DateTime.now().subtract(Duration(days: 16)));
      await tester.pumpAndSettle();
      //Lướt đến hết màn hình
      await tester.scrollUntilVisible(
          find.text('Tiêu đề được thay đổi'), 10000);
      await tester.pumpAndSettle();
      //kiểm tra số lượng phần từ có đầy đủ không
      expect(provider.notes.length, 11);

      expect(find.text('Tiêu đề được thay đổi'), findsOneWidget);
    });
  });

  group("Màn hình sửa note", () {
    testWidgets("Vào màn hình Chi tiết Note", (WidgetTester tester) async {
      MaterialApp app = MaterialApp(
        title: 'Small Habits',
        initialRoute: "/",
        onUnknownRoute: (setting) => MaterialPageRoute(
            builder: (_) =>
                Center(child: Text("Không thể tìm thấy trang này"))),
        supportedLocales: [Locale('vi', 'VI'), Locale('en', 'US')],
        localeListResolutionCallback: (locales, supportedLocales) {
          for (Locale locale in locales!)
            if (supportedLocales.contains(locale)) return locale;
          return Locale('vi', 'VI');
        },
        locale: Locale('vi', 'VI'),
        onGenerateRoute: (settings) {
          WidgetBuilder builder =
              (_) => Center(child: Text("Can't find route name"));
          switch (settings.name) {
            case "/":
              builder = (_) => HomeContainer();
              break;
            case CreateNotePage.nameRoute:
              builder = (_) => CreateNotePage();
              break;
            case NoteDetails.nameRoute:
              // Cast the arguments to the correct
              // type: Note.
              try {
                Note note = settings.arguments as Note;
                builder = (_) => NoteDetails.view(note);
              } catch (e) {
                print("Phải có object Note");
              }
              break;
            default:
              // The assertion here will help remind
              // us of that higher up in the call stack, since
              // this assertion would otherwise fire somewhere
              // in the framework.
              assert(false, 'Need to implement ${settings.name}');
          }

          MaterialPageRoute route = MaterialPageRoute(
            builder: builder,
          );
          return route;
        },
      );

      await tester.pumpWidget(MaterialApp(
          home: ChangeNotifierProvider<NotesProvider>(
        create: (_) => provider,
        lazy: true,
        child: app,
      )));

      await tester.pumpAndSettle(Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.event_note_rounded));
      await tester.pumpAndSettle();
      // //kiểm tra có dữ liệu không
      expect(provider.notes.length > 0, true);
      //kiểm tra có widget danh sách không
      expect(find.byType(DailyNotes), findsWidgets);

      await tester.tap(find.text('Tiêu đề mới nhất'));
      await tester.pumpAndSettle();
      expect(find.byType(DailyNotes), findsNothing);
      expect(find.text('Tiêu đề mới nhất'), findsOneWidget);
    });
  });
}
