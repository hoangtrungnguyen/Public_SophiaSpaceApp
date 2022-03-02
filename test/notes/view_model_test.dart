import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

import 'test_helper.dart';

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late NotesViewModel noteViewModel;
  late NoteFirebaseRepository repository;

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    fireStore = FakeFirebaseFirestore();
    repository =
        NoteFirebaseRepository(firestore: fireStore, auth: mockFirebaseAuth);
    noteViewModel = NotesViewModel(repository: repository);
    await TestHelper.initialRandomTimeNoteRegular(repository);
    await noteViewModel.loadMore();
  });

  test("Read: Có sắp xếp theo thời gian tạo", () async {
    // kiểm tra ngẫu nghiên
    for (int _ in [1, 2]) {
      int length = noteViewModel.notes.length;
      int randomIndex = Random().nextInt(length - 1);
      if (randomIndex == 0) randomIndex += 1;
      expect(
          noteViewModel.notes[randomIndex - 1].note.timeCreated
              .isAfter(noteViewModel.notes[randomIndex].note.timeCreated),
          true);
    }

  });

  test("Read: LoadMore function", () async {

    // kiểm tra ngẫu nghiên
    for (int _ in [1, 2]) {
      int length = noteViewModel.notes.length;
      int randomIndex = Random().nextInt(length - 1);
      if (randomIndex == 0) randomIndex += 1;
      expect(
          noteViewModel.notes[randomIndex - 1].note.timeCreated
              .isAfter(noteViewModel.notes[randomIndex].note.timeCreated),
          true);
    }

     await noteViewModel.loadMore();
     await noteViewModel.loadMore();
     await noteViewModel.loadMore();
    expect(noteViewModel.notes.length, 15);
  });

  test("Create: Tạo note", () async {
    Note note = Note(
        title: 'test1',
        description: "Nội dung test 1",
        emotionPoint: 8,
        activities: List.from([
          defaultActivities[0],
          defaultActivities[1],
          defaultActivities[2],
        ]));
    bool isOk = await noteViewModel.add(note: note);

    expect(isOk, true);
  });

  test("Update: Sửa các trường: Title, Point, Title, Description, TimeCreated",
      () async {
    Note note = (noteViewModel.notes[2].note as Note)
      ..title = "New Title 2"
      ..description = "New Description 2";
    noteViewModel.notes[2].note = note;

    await noteViewModel.update(note: noteViewModel.notes[2].note);
    final doc = await repository.notesRef.doc(note.id).get();
    expect(doc.get('title'), 'New Title 2');
    expect(doc.get('description'), 'New Description 2');
  });

  test("Update: Sửa activities", () async {

    noteViewModel.notes[2].addActivity(defaultActivities[2]);
    noteViewModel.notes[2].addActivity(defaultActivities[5]);
    noteViewModel.notes[2].addActivity(defaultActivities[1]);

    await noteViewModel.update(note: noteViewModel.notes[2].note);


    final found = noteViewModel.notes[2].note as Note;

    expect((found).activities.contains(defaultActivities[5]), true);
    expect((found).activities.contains(defaultActivities[2]), true);
    expect((found).activities.contains(defaultActivities[1]), true);
  });

  test("Update: Dữ liệu vẫn đúng thứ tự sau khi cập nhật", () async {
    // Note testNote = Note(title: "Test Note", description: "Test");
    // await noteViewModel.add(note: testNote);
    //
    // //Để thời gian xa hơn 15 ngày
    // testNote.timeCreated = DateTime.now().subtract(Duration(days: 50));
    //
    // noteViewModel.update(viewModel: testNote);
    //
    // // Kiểm tra ngẫu nghiên
    // for (int _ in [1, 2]) {
    //   int length = noteViewModel.notes.length;
    //   int randomIndex = Random().nextInt(length - 1);
    //   if (randomIndex == 0) randomIndex += 1;
    //   expect(
    //       noteViewModel.notes[randomIndex - 1].note.timeCreated
    //           .isAfter(noteViewModel.notes[randomIndex].note.timeCreated),
    //       true);
    // }
    // await noteViewModel.loadMore();
    // await noteViewModel.loadMore();
    //
    // expect(noteViewModel.notes[noteViewModel.notes.length - 1].note == testNote, true);
  });

  test("Delete", () async {

  });
}
