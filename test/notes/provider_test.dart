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

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late NotesProvider provider;

  setUpAll(() {
    mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
    fireStore = FakeFirebaseFirestore();
  });

  group("Kiểm tra dữ trước khi tải lên liệu", () {
    setUp(() {
      provider = NotesProvider(
          auth: mockFirebaseAuth,
          fireStore: fireStore,
          isTesting: true);
    });

    tearDown(() async {
      QuerySnapshot snapshots = await provider.notesRef.get();
      await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
        await doc.reference.delete();
      });
    });

    test("1/ Dữ liệu hợp lệ", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: LinkedHashSet.from([
            activities[0],
            activities[1],
            activities[2],
          ]));

      Result result = await provider.addNote(note: note);
      expectLater(result.data != null, true);
    });

    test("2/ Trường 'activitiesPoint' không hợp lệ", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: -1,
          activities: LinkedHashSet.from([
            activities[0],
            activities[1],
            activities[2],
          ]));
      Result result = await provider.addNote(note: note);
      expectLater(result.data == null, true);
    });

    test("3/ Trường 'activities' không hợp lệ", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: 0,
          activities: LinkedHashSet.from([]));
      Result result = await provider.addNote(note: note);
      expectLater(result.data == null, true);
    });
  });

  //Dùng chung Provider ban đầu
  group("Đọc dữ liệu", () {
    setUp(() async {
      provider = NotesProvider(
          auth: mockFirebaseAuth,
          fireStore: fireStore,
          isTesting: true);
    });

    tearDown(() async {
      QuerySnapshot snapshots =
          await fireStore.collection(mockFirebaseAuth.currentUser!.uid).get();
      await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
        await doc.reference.delete();
      });
    });

    test("Kiểm tra hàm quickSort", () {
      List<int>.generate(10, (i) => i).forEach((int e) async {
        Note note = Note(
            title: 'title$e',
            description: "Nội dung test $e",
            emotionPoint: Random().nextInt(10),
            activities: LinkedHashSet.from([
              activities[0],
              activities[1],
              activities[2],
            ]));
        note
          ..timeCreated =
              DateTime.now().subtract(Duration(days: Random().nextInt(15),
              seconds: Random().nextInt(60)));
        provider.notes.add(note);
      });
      provider.sort();
      print(provider.notes);
      //Kiểm tra độ dài
      expect(provider.notes.length, 10);
      // kiểm tra ngẫu nghiên
      for (int _ in [0,0,0,0,0]) {
        int length = provider.notes.length;
        int randomIndex = Random().nextInt(length - 1);
        if (randomIndex == 0) randomIndex += 1;
        // print(
        //     "Data from index ${randomIndex - 1}: ${provider.notes[randomIndex - 1]}"
        //     "\nData from index ${randomIndex}: ${provider.notes[randomIndex]}");
        expect(
            provider.notes[randomIndex - 1].timeCreated
                .isAfter(provider.notes[randomIndex].timeCreated),
            true);
        print("-----------------------------");
      }
    });

    test("1/ Đọc dữ liệu và parse Json thành công", () async {
      await Future.forEach(List<int>.generate(10, (i) => i + 1), (int e) async {
        Note note = Note(
            title: 'test1',
            description: "Nội dung test 1",
            emotionPoint: 8,
            activities: LinkedHashSet.from([
              activities[0],
              activities[1],
              activities[2],
            ]));
        Result result = await provider.addNote(note: note..title = 'title$e');
        expect(result.data != null, true);
      });
      await provider.loadMoreNotes();
      print(provider.notes);
      expect(provider.notes.length, 10);
    });

    test("2/ Dữ liệu có sắp xếp theo ngày tạo sớm nhất", () async {
      await Future.forEach(List<int>.generate(10, (i) => i), (int i) async {
        Note note = Note(
            title: 'title$i',
            description: "Nội dung test $i",
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

      //kiểm tra số lượng
      expect(provider.notes.length, 10);

      // kiểm tra ngẫu nghiên
      for (int _ in [1, 2]) {
        int length = provider.notes.length;
        int randomIndex = Random().nextInt(length - 1);
        if (randomIndex == 0) randomIndex += 1;
        // print(
        //     "Data from index ${randomIndex - 1}: ${provider.notes[randomIndex - 1]}"
        //     "\nData from index ${randomIndex}: ${provider.notes[randomIndex]}");
        expect(
            provider.notes[randomIndex - 1].timeCreated
                .isAfter(provider.notes[randomIndex].timeCreated),
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
            activities: LinkedHashSet.from([
              activities[0],
              activities[1],
              activities[2],
            ]));
        note
          ..timeCreated =
          //Random thời gina trong 15 ngày
              DateTime.now().subtract(Duration(days: Random().nextInt(15)));
        //Chọn note để cập nhật
        if(i == 2)
          testNote = note;
        await provider.addNote(note: note);
      });

      //kiểm tra số lượng
      expect(provider.notes.length, 10);

      testNote.title = "Updated title";
      //Để thời gian xa hơn 15 ngày
      testNote.timeCreated = DateTime.now().subtract(Duration(days: 50));

      provider.updateNote(testNote);

      // kiểm tra ngẫu nghiên
      for (int _ in [1, 2]) {
        int length = provider.notes.length;
        int randomIndex = Random().nextInt(length - 1);
        if (randomIndex == 0) randomIndex += 1;
        expect(
            provider.notes[randomIndex - 1].timeCreated
                .isAfter(provider.notes[randomIndex].timeCreated),
            true);
      }

      //Kiểm tra phần từ cuối cùng
      expect(provider.notes[provider.notes.length-1] == testNote, true);
    });
  });
}
