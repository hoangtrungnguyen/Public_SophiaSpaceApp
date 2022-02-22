import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/repository/auth_repository.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/view/page/home/notes.dart';
import 'package:sophia_hub/view/page/home/notes/single_item_note.dart';
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

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    mockFirebaseStorage = MockFirebaseStorage();
    fireStore = FakeFirebaseFirestore();

    repository =
        NoteFirebaseRepository(firestore: fireStore, auth: mockFirebaseAuth);
    notesViewModel = NotesViewModel(repository: repository);

    authRepository =
        AuthRepository(auth: mockFirebaseAuth, storage: mockFirebaseStorage);
    await TestHelper.initialData(repository);

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
          home: Scaffold(body: NotesView())),
    );
  });

  testWidgets("Read: hiển thị đúng thứ tự thời gian",
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);

    await tester.pump();

    //kiểm tra có dữ liệu không
    expect(notesViewModel.notes.length > 0, true);

    //kiểm tra có widget danh sách không
    expect(find.byType(NoteItem), findsWidgets);
  });

  testWidgets("Read: lần đầu hiển thị", (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);
    await tester.pump();
    //kiểm tra có dữ liệu không
    expect(notesViewModel.notes.length > 0, true);

    //kiểm tra có widget danh sách không
    expect(find.byType(NoteItem), findsWidgets);
  });

  testWidgets("Read: thêm một Note", (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);

    await notesViewModel.add(
        note: Note(
      title: 'Tiêu đề mới nhất',
      description: "Nội dung test 1",
      emotionPoint: 8,
    ));

    await tester.pumpAndSettle();

    expectLater(find.text("Tiêu đề mới nhất"), findsOneWidget);
  });
}
