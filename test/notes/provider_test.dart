import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/model/emotion.dart';
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
          uid: mockFirebaseAuth.currentUser!.uid,
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
          emotions: LinkedHashSet.from([
            emotions[0],
            emotions[1],
            emotions[2],
          ]));

      Result result = await provider.addNote(note: note);
      expectLater(result.data != null, true);
    });

    test("2/ Trường 'emotionsPoint' không hợp lệ", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: -1,
          emotions: LinkedHashSet.from([
            emotions[0],
            emotions[1],
            emotions[2],
          ]));
      Result result = await provider.addNote(note: note);
      expectLater(result.data == null, true);
    });

    test("3/ Trường 'emotions' không hợp lệ", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: 0,
          emotions: LinkedHashSet.from([]));
      Result result = await provider.addNote(note: note);
      expectLater(result.data == null, true);
    });
  });

  //Dùng chung Provider ban đầu
  group("Đọc dữ liệu", () {
    setUp(() async {
      provider = NotesProvider(
          uid: mockFirebaseAuth.currentUser!.uid,
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

    test("1/ Đọc dữ liệu thành công và parse Json", () async {
      Note note = Note(
          title: 'test1',
          description: "Nội dung test 1",
          emotionPoint: 8,
          emotions: LinkedHashSet.from([
            emotions[0],
            emotions[1],
            emotions[2],
          ]));

      Result result = await provider.addNote(note: note);
      result = await provider.addNote(note: note..title = 'title2');
      result = await provider.addNote(note: note..title = 'title3');
      expect(result.data != null, true);
      await provider.loadMoreNotes();
      expect(provider.notes.length, 3);
    });
  });
}
