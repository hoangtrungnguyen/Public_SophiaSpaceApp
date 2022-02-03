import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/notes_provider.dart';

import '../helper/test_helper.dart';

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late NotesPublisher publisher;

  setUpAll(() {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    fireStore = FakeFirebaseFirestore();
  });

  group("Các hàm logic", () {
    setUp(() {
      publisher = NotesPublisher(auth: mockFirebaseAuth, fireStore: fireStore, isTesting: true);
    });

    tearDown(() async {
      TestHelper.clearUserData(publisher);
    });

    test("Hàm group", () {});

    test("Hàm insertedSort", () {
      List<int>.generate(10, (i) => i).forEach((int e) async {
        Note note = Note(
            title: 'title$e',
            description: "Nội dung test $e",
            emotionPoint: 1,
            activities: List.from([
              activities[0],
            ]));
        note..timeCreated = DateTime.now().subtract(Duration(days: e));
        publisher.notes.add(note);
      });

      Note note = Note(
          title: 'TEST NOTE',
          description: "TEST",
          emotionPoint: 1,
          activities: List.from([
            activities[0],
          ]))
        ..timeCreated = DateTime.now().subtract(Duration(days: 3));

      int i = publisher.insertSorted(note);
      print(publisher.notes);
      expect(publisher.notes[3].title, "TEST NOTE");
      expect(i, 3);

      note = Note(
          title: 'TEST NOTE 2',
          description: "TEST",
          emotionPoint: 1,
          activities: List.from([
            activities[0],
          ]))
        ..timeCreated = DateTime.now();

      int y = publisher.insertSorted(note);
      print(publisher.notes);
      expect(publisher.notes[0].title, "TEST NOTE 2");
      expect(y, 0);
    });
  });

  group("Kiểm tra dữ trước khi tải lên liệu", () {
    setUp(() {
      publisher = NotesPublisher(
          auth: mockFirebaseAuth, fireStore: fireStore, isTesting: true);
    });

    tearDown(() async {
      QuerySnapshot snapshots = await publisher.notesRef.get();
      await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
        await doc.reference.delete();
      });
    });

    test("1/ Dữ liệu hợp lệ", () async {
      //Data mẫu
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: List.from([
            activities[0],
            activities[1],
            activities[2],
          ]));
      Result result = await publisher.addNote(note: note);
      print(result.data);
      expectLater(result.data != null, true);
    });

    test("2/ Trường 'activitiesPoint' không hợp lệ", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: -1,
          activities: List.from([
            activities[0],
            activities[1],
            activities[2],
          ]));
      Result result = await publisher.addNote(note: note);
      expectLater(result.data == null, true);
    });

    test("3/ Trường 'activities' không hợp lệ", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: 0,
          activities: List.from([]));
      Result result = await publisher.addNote(note: note);
      expectLater(result.data == null, true);
    });
  });

  //Dùng chung Provider ban đầu
  group("Đọc dữ liệu", () {
    setUp(() async {
      publisher = NotesPublisher(
          auth: mockFirebaseAuth, fireStore: fireStore, isTesting: true);
    });

    tearDown(() async {
      QuerySnapshot snapshots =
      await fireStore.collection(mockFirebaseAuth.currentUser!.uid).get();
      await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
        await doc.reference.delete();
      });
    });
    test("1/ Đọc dữ liệu và parse Json thành công", () async {
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
        Result result = await publisher.addNote(note: note..title = 'title$e');
        expect(result.data != null, true);
      });
      await publisher.loadMoreNotes();
      print(publisher.notes);
      expect(publisher.notes.length, 10);
    });

    test("2/ Dữ liệu có sắp xếp theo ngày tạo sớm nhất", () async {
      await Future.forEach(List<int>.generate(10, (i) => i), (int i) async {
        Note note = Note(
            title: 'title$i',
            description: "Nội dung test $i",
            emotionPoint: Random().nextInt(10),
            activities: List.from([
              activities[0],
              activities[1],
              activities[2],
            ]));
        note
          ..timeCreated =
              DateTime.now().subtract(Duration(days: Random().nextInt(15)));
        await publisher.addNote(note: note);
      });

      //kiểm tra số lượng
      expect(publisher.notes.length, 10);

      // kiểm tra ngẫu nghiên
      for (int _ in [1, 2]) {
        int length = publisher.notes.length;
        int randomIndex = Random().nextInt(length - 1);
        if (randomIndex == 0) randomIndex += 1;
        // print(
        //     "Data from index ${randomIndex - 1}: ${provider.notes[randomIndex - 1]}"
        //     "\nData from index ${randomIndex}: ${provider.notes[randomIndex]}");
        expect(
            publisher.notes[randomIndex - 1].timeCreated
                .isAfter(publisher.notes[randomIndex].timeCreated),
            true);
        // print("-----------------------------");
      }
    });

    test("3/ Dữ liệu có sắp xếp từ sớm nhất sau khi cập nhật note", () async {
      late Note testNote;
      await Future.forEach(List<int>.generate(10, (i) => i), (int i) async {
        Note note = Note(
            title: 'Tiêu đề - $i',
            description: "Nội dung test $i",
            emotionPoint: Random().nextInt(10),
            activities: List.from([
              activities[0],
              activities[1],
              activities[2],
            ]));
        note
          ..timeCreated =
              //Random thời gina trong 15 ngày
              DateTime.now().subtract(Duration(days: Random().nextInt(15)));
        //Chọn note để cập nhật
        if (i == 2) testNote = note;
        await publisher.addNote(note: note);
      });

      //kiểm tra số lượng
      expect(publisher.notes.length, 10);

      testNote.title = "Updated title";
      //Để thời gian xa hơn 15 ngày
      testNote.timeCreated = DateTime.now().subtract(Duration(days: 50));

      publisher.updateNote(testNote);

      // kiểm tra ngẫu nghiên
      for (int _ in [1, 2]) {
        int length = publisher.notes.length;
        int randomIndex = Random().nextInt(length - 1);
        if (randomIndex == 0) randomIndex += 1;
        expect(
            publisher.notes[randomIndex - 1].timeCreated
                .isAfter(publisher.notes[randomIndex].timeCreated),
            true);
      }

      print(publisher.notes);
      //Kiểm tra phần từ cuối cùng
      expect(publisher.notes[publisher.notes.length - 1] == testNote, true);
    });
  });

  group("Sửa dữ liệu", () {
    setUp(() async {
      publisher = NotesPublisher(
          auth: mockFirebaseAuth, fireStore: fireStore, isTesting: true);
      await Future.forEach(List<int>.generate(10, (i) => i), (int i) async {
        //Data mẫu
        Note note = Note(
            title: 'test1',
            description: "Nội dung test 1",
            emotionPoint: 8,
            activities: List.from([
              activities[0],
              activities[1],
              activities[2],
            ]));

        note
          ..title = "Title - $i"
          ..timeCreated =
              //Random thời gina trong 15 ngày
              DateTime.now().subtract(Duration(days: Random().nextInt(15)));

        await publisher.addNote(note: note);
      });
    });

    tearDown(() async {
      QuerySnapshot snapshots =
          await fireStore.collection(mockFirebaseAuth.currentUser!.uid).get();
      await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
        await doc.reference.delete();
      });
    });

    test("Sửa các trường: Title, Point, Title, Description, TimeCreated",
        () async {
      Note note = publisher.notes[2]
        ..title = "New Title 2"
        ..description = "New Description 2";
      publisher.loadMoreNotes();
      publisher.updateNote(note);
      final doc = await publisher.notesRef.doc(note.id).get();
      expect(doc.get('title'), 'New Title 2');
      expect(doc.get('description'), 'New Description 2');
    });
    test("Sửa activities", () async {
      Note note = publisher.notes[2]
        ..activities = List.from([activities[2], activities[5], activities[1]]);
      await publisher.updateNote(note);
      Result res = await publisher.getById(note.id);
      expect((res.data['note'] as Note).activities.contains(activities[5]), true);
      expect((res.data['note'] as Note).activities.contains(activities[2]), true);
      expect((res.data['note'] as Note).activities.contains(activities[1]), true);
    });
  });
}
