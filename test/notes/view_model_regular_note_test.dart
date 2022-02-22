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
  late NotesViewModel viewModel;
  late NoteFirebaseRepository repository;

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    fireStore = FakeFirebaseFirestore();
    repository =
        NoteFirebaseRepository(firestore: fireStore, auth: mockFirebaseAuth);
    viewModel = NotesViewModel(repository: repository);
    await TestHelper.initialData(repository);
    await viewModel.loadMore();
  });

  test("Read: Có sắp xếp theo thời gian tạo", () async {
    expect(viewModel.notes.length, 10);

    // kiểm tra ngẫu nghiên
    for (int _ in [1, 2]) {
      int length = viewModel.notes.length;
      int randomIndex = Random().nextInt(length - 1);
      if (randomIndex == 0) randomIndex += 1;
      expect(
          viewModel.notes[randomIndex - 1].note.timeCreated
              .isAfter(viewModel.notes[randomIndex].note.timeCreated),
          true);
    }
  });

  test("Read: LoadMore function", () async {
    expect(viewModel.notes.length, 10);

    // kiểm tra ngẫu nghiên
    for (int _ in [1, 2]) {
      int length = viewModel.notes.length;
      int randomIndex = Random().nextInt(length - 1);
      if (randomIndex == 0) randomIndex += 1;
      expect(
          viewModel.notes[randomIndex - 1].note.timeCreated
              .isAfter(viewModel.notes[randomIndex].note.timeCreated),
          true);
    }

     await viewModel.loadMore();;
    expect(viewModel.notes.length, 15);
  });

  test("Create: Tạo note", () async {
    Note note = Note(
        title: 'test1',
        description: "Nội dung test 1",
        emotionPoint: 8,
        activities: List.from([
          activities[0],
          activities[1],
          activities[2],
        ]));
    bool isOk = await viewModel.add(note: note);

    expect(isOk, true);
  });

  test("Update: Sửa các trường: Title, Point, Title, Description, TimeCreated",
      () async {
    Note note = (viewModel.notes[2].note as Note)
      ..title = "New Title 2"
      ..description = "New Description 2";

    await viewModel.update(note: note);
    final doc = await repository.notesRef.doc(note.id).get();
    expect(doc.get('title'), 'New Title 2');
    expect(doc.get('description'), 'New Description 2');
  });

  test("Update: Sửa activities", () async {

    viewModel.notes[2].addActivity(activities[2]);
    viewModel.notes[2].addActivity(activities[5]);
    viewModel.notes[2].addActivity(activities[1]);

    await viewModel.update(note: viewModel.notes[2].note);


    final found = viewModel.notes[2].note;

    expect((found).activities.contains(activities[5]), true);
    expect((found).activities.contains(activities[2]), true);
    expect((found).activities.contains(activities[1]), true);
  });

  test("Update: Dữ liệu vẫn đúng thứ tự sau khi cập nhật", () async {
    Note testNote = Note(title: "Test Note", description: "Test");
    await viewModel.add(note: testNote);

    //Để thời gian xa hơn 15 ngày
    testNote.timeCreated = DateTime.now().subtract(Duration(days: 50));
    viewModel.update(note: testNote);

    // Kiểm tra ngẫu nghiên
    for (int _ in [1, 2]) {
      int length = viewModel.notes.length;
      int randomIndex = Random().nextInt(length - 1);
      if (randomIndex == 0) randomIndex += 1;
      expect(
          viewModel.notes[randomIndex - 1].note.timeCreated
              .isAfter(viewModel.notes[randomIndex].note.timeCreated),
          true);
    }
    await viewModel.loadMore();
    await viewModel.loadMore();

    expect(viewModel.notes[viewModel.notes.length - 1].note == testNote, true);
  });

  test("Delete", () async {

  });
}
