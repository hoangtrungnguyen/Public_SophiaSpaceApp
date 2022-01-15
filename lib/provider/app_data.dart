import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/model/task.dart';

class AppData extends ChangeNotifier {
  List<Task> tasks = [];
  List<Note> notes = [];
  List<Quote> quotes = [];
  String uid;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference notesRef;
  CollectionReference tasksRef;

  Query notesQuery;
  //Save the last doc for pagination purpose
  DocumentSnapshot lastNoteDoc;

  AppData() {
    this.uid = FirebaseAuth.instance.currentUser.uid;

    this.notesRef = fireStore
        .collection(FirebaseKeyword.dataCollection)
        .doc(this.uid)
        .collection(FirebaseKeyword.notes);
    this.tasksRef = fireStore
        .collection(FirebaseKeyword.dataCollection)
        .doc(this.uid)
        .collection(FirebaseKeyword.tasks);

    this.notesQuery = getNotesQuery();
    loadMoreNotes();
  }

  /// [addNote] adding a note
  /// This function will add note to firebase storage
  ///
  /// [todayId] day since epoch for the day that user wants to add note
  Future<Result> addNote({String todayId, @required Note note}) async {
    try {
      this.notesRef.doc().set({
        "title": note.title,
        "description": note.description,
        "day": todayId
      });

      return Result(data: "OK", err: null);
    } catch (e) {
      print("Failed to add user: $e");
      return Result(data: null, err: e);
    }
  }

  ///
  Query getNotesQuery() => notesRef.limit(10);

  loadMoreNotes() async {
    if (notes.isNotEmpty && lastNoteDoc != null)
      notesQuery =
          notesQuery.startAfterDocument(lastNoteDoc);

    QuerySnapshot querySnapshot = await notesQuery.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    if(docs.isNotEmpty) this.lastNoteDoc = docs.last;
    this.notes.addAll(docs.map((e) {
          return Note(
            title: e.get("title"),
            description: e.get("description"),
          );
        }).toList());
    notifyListeners();
  }
}
