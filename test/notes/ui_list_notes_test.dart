import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/repository/auth_repository.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/view/page/home/notes/note_tab_single_item_content.dart';
import 'package:sophia_hub/view/page/home/notes/note_tab_view.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

import 'test_helper.dart';

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseStorage mockFirebaseStorage;
  late FakeFirebaseFirestore fireStore;
  late NoteFirebaseRepository repository;
  late AuthRepository authRepository;
  late NotesViewModel notesViewModel;
  late Widget testWidget;
  int initialNotesCount = 10;

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    mockFirebaseStorage = MockFirebaseStorage();
    fireStore = FakeFirebaseFirestore();

    repository =
        NoteFirebaseRepository(firestore: fireStore, auth: mockFirebaseAuth);
    notesViewModel = NotesViewModel(repository: repository);

    authRepository = AuthRepository(
        auth: mockFirebaseAuth,
        storage: mockFirebaseStorage,
        firestore: fireStore);

    testWidget = MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountViewModel>(
          create: (_) => AccountViewModel(repository: authRepository),
        ),
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => notesViewModel,
        ),
      ],
      child: MaterialApp(
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
          home: Scaffold(body: NoteTabView())),
    );
  });

  tearDown(() async {});

  group(("Read"), () {


    testWidgets("Hiển thị", (WidgetTester tester) async {
      await TestHelper.initialRandomTimeNoteRegular(repository,
          size: initialNotesCount);

      await tester.pumpWidget(testWidget);

      await tester.pump();

      //kiểm tra có widget danh sách không
      expect(find.byType(NoteSingleItemContent), findsWidgets);
    });

    testWidgets("Thêm một Note", (WidgetTester tester) async {
      await TestHelper.initialRandomTimeNoteRegular(repository,
          size: initialNotesCount);

      await tester.pumpWidget(testWidget);

      expect((await repository.notesRef.get()).size, initialNotesCount);

      await notesViewModel.add(
          note: Note(
        title: 'Tiêu đề mới nhất',
        description: "Nội dung test 1",
        emotionPoint: 8,
        activities: [defaultActivities[2]],
      ));

      expect((await repository.notesRef.get()).size, initialNotesCount + 1);

      await tester.idle();

      expect(notesViewModel.notes.first.note.title, 'Tiêu đề mới nhất');

      expectLater(find.text("Tiêu đề mới nhất"), findsOneWidget);
    });


    testWidgets("Pagination", (WidgetTester tester) async {
      // List<Note> notes = await TestHelper.initialRandomTimeNoteRegular(repository,
      //     size: initialNotesCount);
      // notes.sort((Note note, Note note2) => note.timeCreated.compareTo(note2.timeCreated));
      // Note oldestNote = notes.first;
      //
      // await tester.pumpWidget(testWidget);
      // await tester.pump();
      //
      // expect(notesViewModel.notes.length, 5);
      // await tester.dragFrom(Offset(0,200),Offset(0,-200));
      // await tester.dragFrom(Offset(0,200),Offset(0,-200));
      // await tester.dragFrom(Offset(0,200),Offset(0,-200));
      // await tester.dragFrom(Offset(0,200),Offset(0,-200));
      // await tester.dragFrom(Offset(0,200),Offset(0,-200));
      // await tester.idle();
      // expect(notesViewModel.notes.length, initialNotesCount);

    });
  });
}
