import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/repository/note_repository.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

class TestHelper {
  static Future<List<Note>> initialRandomTimeNoteRegular(
      NoteFirebaseRepository noteRepository,
      {int size = 15}) async {
    return await Future.wait<Note>(List<Future<Note>>.generate(size, (i) async {
      Note note = Note(
          title: 'Title - $e',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: List.from([
            defaultActivities[0],
            defaultActivities[1],
            defaultActivities[2],
          ]));
      //Random thời gina trong 15 ngày
      note..timeCreated =
            DateTime.now().subtract(Duration(days: Random().nextInt(15)));
      Result result = await noteRepository.create(note);
      return result.data as Note;
    }));
  }

  static Future<List<Note>> initialRegularNote(
      NoteFirebaseRepository noteRepository,
      {int size = 15}) async {
    return await Future.wait<Note>(List<Future<Note>>.generate(size, (i) async {
      Note note = Note(
          title: 'Title - $e',
          description: "Nội dung test 1",
          emotionPoint: 8,
          activities: List.from([
            defaultActivities[0],
            defaultActivities[1],
            defaultActivities[2],
          ]));
      await Future.delayed(Duration(milliseconds: 50));
      Result result = await noteRepository.create(note);
      return result.data as Note;
    }));
  }

  static Future clearUserData(NoteFirebaseRepository repository) async {
    QuerySnapshot snapshots = await repository.notesRef.get();
    await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
      await doc.reference.delete();
    });
  }
}
