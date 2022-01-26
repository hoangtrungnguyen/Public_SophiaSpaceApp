import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/app_data.dart';
import 'dart:collection';

import 'package:sophia_hub/provider/connection_state.dart';

class NotesProvider extends App
    with ConnectionState
    implements ReassembleHandler {
  final isTesting;
  List<Note> notes = [];

  //Không thể null
  late CollectionReference notesRef;
  Query? notesQuery;
  FirebaseFirestore fireStore;
  FirebaseAuth auth;

  //Save the last doc for pagination purpose
  DocumentSnapshot? lastNoteDoc;

  NotesProvider({
    required this.fireStore,
    required this.auth,
    this.isTesting = false,
  }) {
    config();
  }

  /// [addNote] adding a note
  /// This function will add note to firebase storage
  /// This function also checks initial input
  Future<Result> addNote({required Note note}) async {
    try {
      if (!note.isValid()) {
        return Result(err: FormatException("Dữ liệu không hợp lệ"));
      }

      DocumentReference currentDoc = this.notesRef.doc();

      // set emotion objects
      CollectionReference activityRef = currentDoc.collection(FirebaseKey.activities);
      WriteBatch batch = this.fireStore.batch();
      for (final emotion in note.activities) {
        batch.set(activityRef.doc(emotion.id), emotion.toJson());
      }
      await batch.commit();

      //Cập nhật danh sách lên server
      await currentDoc.set(note.toJson());

      //Cập nhật trường id
      note.id = currentDoc.id;

      //Thêm note vào danh sách hiện tại
      this.notes.add(note);
      //Sắp xếp lại danh sách theo thời gian tạo
      sort();

      return Result(data: "OK", err: null);
    } catch (e) {
      print("Failed to add user: $e");
      return Result(data: null, err: Exception("Failed to add user: $e"));
    }
  }

  sort() {
    notes.sort((a, b) => a.timeCreated.isAfter(b.timeCreated) ? -1 : 1);
  }
  count(){
  }

  Query getNotesQuery() =>
      notesRef.orderBy('time_created', descending: true).limit(10);

  loadMoreNotes() async {
    this.isLoading = true;
    notifyListeners();
    try {
      if (this.notesQuery == null) {
        this.notesQuery = getNotesQuery();
      }

      if (notes.isNotEmpty && lastNoteDoc != null && notesQuery != null)
        notesQuery = notesQuery!.startAfterDocument(lastNoteDoc!);

      QuerySnapshot querySnapshot = await notesQuery!.get();

      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      if (docs.isNotEmpty) this.lastNoteDoc = docs.last;

      await Future.forEach<QueryDocumentSnapshot>(docs, (e) async {
        Note note = Note.fromJson(e.data() as Map<String, dynamic>);
        note.id = e.id;

        note.activities.addAll(
            (await notesRef.doc(e.id).collection(FirebaseKey.activities).get())
                .docs
                .map((e) {
          return Activity.fromJson(e.data())
            ..icon = activities.firstWhere((element) => element.id == e.id).icon;
        }));

        //Kiểm tra note này đã tồn tại trong danh sách chưa?
        if (!this.notes.contains(note)) this.notes.add(note);
      });
    } catch (e) {
      print(e);
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  //Cập nhật danh sách và vị trí của phần từ Note vừa được thêm vào và sắp xếp
  // Gọi hàm này sau mỗi lần thêm, sửa danh sách
  Future updateNote(Note note) async {
    if (!this.notes.contains(note))
      print("Note không tồn tại");
    else {
      int i = this.notes.indexOf(note);
      this.notes[i] = note;
    }

    //Sắp xếp lại danh sách theo thời gian tạo
    sort();

    //Cập nhật object cảm xúc
    await notesRef.doc(note.id).update(note.toJson()).then((value) async {
      WriteBatch batch = this.fireStore.batch();
      for (final activity in note.activities) {
        batch.set(notesRef.doc(note.id).collection(FirebaseKey.activities).doc(activity.id),
            activity.toJson());
      }
      await batch.commit();
    });
    notifyListeners();

    return Result(data: "Ok");
  }

  void config() {
    if (auth.currentUser == null) return;
    this.notesRef = fireStore
        .collection(FirebaseKey.dataCollection)
        .doc(auth.currentUser!.uid)
        .collection(FirebaseKey.notes);

    this.notesQuery = getNotesQuery();
  }

  clear() {
    this.notes.clear();
    this.notesQuery = null;
    notifyListeners();
  }

  @override
  void reassemble() {
    // print("HotReload ${this.notes}");
  }
}
