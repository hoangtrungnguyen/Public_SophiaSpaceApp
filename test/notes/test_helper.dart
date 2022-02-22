import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/repository/note_repository.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

class TestHelper {
  static initialData(NoteRepository noteRepository) async {
    await Future.forEach(List<int>.generate(15, (i) => i + 1), (int e) async {
      Note note = Note(
          title: 'Title - $e',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: List.from([
            activities[0],
            activities[1],
            activities[2],
          ]));

      note
        ..timeCreated =
            //Random thời gina trong 15 ngày
            DateTime.now().subtract(Duration(days: Random().nextInt(15)));

      await noteRepository.create(note);
    });
  }

  static Future clearUserData(NoteFirebaseRepository repository) async {
    QuerySnapshot snapshots = await repository.notesRef.get();
    await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
      await doc.reference.delete();
    });
  }
}
