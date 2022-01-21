import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/emotion.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/app_data.dart';

class NotesProvider extends App {
  final isTesting;
  List<Note> notes = [];

  //Không thể null
  late CollectionReference notesRef;
  late Query notesQuery;
  FirebaseFirestore fireStore;

  //Save the last doc for pagination purpose
  DocumentSnapshot? lastNoteDoc;

  NotesProvider({
    required String uid,
    required this.fireStore,
    this.isTesting = false,
  }) {
    this.notesRef = fireStore
        .collection(FirebaseKeyword.dataCollection)
        .doc(uid)
        .collection(FirebaseKeyword.notes);

    this.notesQuery = getNotesQuery();
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
      CollectionReference emotionRef = currentDoc.collection("emotions");
      WriteBatch batch = this.fireStore.batch();
      for (final emotion in note.emotions) {
        batch.set(emotionRef.doc(emotion.id), emotion.toJson());
      }
      await batch.commit();

      await currentDoc.set(note.toJson());

      return Result(data: "OK", err: null);
    } catch (e) {
      print("Failed to add user: $e");
      return Result(data: null, err: Exception("Failed to add user: $e"));
    }
  }

  ///
  Query getNotesQuery() => notesRef.limit(10);

  loadMoreNotes() async {
    if (notes.isNotEmpty && lastNoteDoc != null)
      notesQuery = notesQuery.startAfterDocument(lastNoteDoc!);

    QuerySnapshot querySnapshot = await notesQuery.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    if (docs.isNotEmpty) this.lastNoteDoc = docs.last;

    await Future.forEach<QueryDocumentSnapshot>(docs, (e) async {
      Note note = Note.fromJson(e.data() as Map<String, dynamic>);

      note.emotions.addAll(
          (await notesRef.doc(e.id).collection('emotions').get())
              .docs
              .map((e) => Emotion.fromJson(e.data())));

      this.notes.add(note);
    });
    notifyListeners();
  }

  clear() {
    this.notes.clear();
    notifyListeners();
  }
}
