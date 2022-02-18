import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late NotesViewModel manager;

  initialData() async {
    await Future.forEach(List<int>.generate(10, (i) => i + 1), (int e) async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: List.from([
            activities[0],
            activities[1],
            activities[2],
          ]));
      bool isOk = await manager.add(note: note);
    });
  }

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    fireStore = FakeFirebaseFirestore();
    manager = NotesViewModel(
        repository: NoteFirebaseRepository(
            firestore: fireStore, auth: mockFirebaseAuth));
  });

  test("Create", () async {
    Note note = Note(
        title: 'test1',
        description: "Nội dung test 1",
        emotionPoint: 8,
        activities: List.from([
          activities[0],
          activities[1],
          activities[2],
        ]));
    bool isOk = await manager.add(note: note);

    expect(isOk, true);
  });
}
