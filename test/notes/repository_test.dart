import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';

import 'test_helper.dart';

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late NoteFirebaseRepository repository;
  String uid = "UID";

  setUpAll(() async {});

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: uid,));
    fireStore = FakeFirebaseFirestore();
    repository = NoteFirebaseRepository(firestore: fireStore, auth: mockFirebaseAuth);

  });

  group("Create", () {


    tearDown(() async {
      print(fireStore.dump());
    });


    test("Success: Create 3 notes", () async {
      Note note = Note(
          title: 'Title - test',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: List.from([defaultActivities[0]]));
      Note note1 =note.copyContent()..title = "2";
      Note note2 = note.copyContent()..title = "3";

      Result res = await repository.create(note);
      await repository.create(note1);
      await repository.create(note2);
      final snapshots = await repository.notesRef.get();
      expect(snapshots.size, 3);


      Result foundById = await repository.getById((res.data as Note).id);
      print("after add");
      print(foundById.data);
      print("user input");
      print(note);
      expect((foundById.data as Note) == note, true);

    });

    test("Error: Invalid note's data", () async {
      Note note = Note(
          title: 'Title - test',
          description: "Nội dung test 1",
          emotionPoint: null,
          activities: List.from([defaultActivities[0]]));
      Result result = await repository.create(note);
      expect(result.isHasErr, true);
      expect(result.error, isA<FormatException>());
    });

  });

  group("Read", () {

    test("Read: once regular note", () async {
      Note note = Note(
          title: 'Title - test',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: List.from([defaultActivities[0],defaultActivities[1]]));
      Result result = await repository.create(note);

      Result<GenericNote> found = await repository.getById((result.data as GenericNote).id);

      expect((found.data as Note).activities.length, 2);


    });
    test("Read: loadMore once", () async {
      List<Note> notes = await TestHelper.initialRegularNote(repository, size: 5);
      Result<List<GenericNote>> result = await repository.loadMore();
      expect((result.data as List).length, 5);
    });

    test("Read: loadMore twice", () async {
      // TODO can not understand why start after doesn't work on test
      List<Note> notes = await TestHelper.initialRegularNote(repository, size: 6);
      expect(notes.length, 6);

      Result<List<GenericNote>> result = await repository.loadMore();
      expect((result.data as List).length, 5);
    });

  });

  group("Delete", (){
    test("Delete success", () async {
      List<Note> notes = await TestHelper.initialRegularNote(repository, size: 5);
      Result res = await repository.delete(notes[2]);
      expect(res.isHasData, true);
      Result<List<GenericNote>> result = await repository.loadMore();
      expect((result.data as List).length, 4);

    });

  });


}
