import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_repository.dart';

class NoteFirebaseRepository extends NoteRepository {
  late FirebaseFirestore _firestore;

  late CollectionReference notesRef;

  Query? query;

  //Last doc for pagination purpose
  DocumentSnapshot? lastDoc;

  NoteFirebaseRepository({FirebaseFirestore? firestore, FirebaseAuth? auth}) {
    _firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) return;
    this.notesRef = _firestore
        .collection(FirebaseKey.dataCollection)
        .doc(auth.currentUser!.uid)
        .collection(FirebaseKey.notes);

    this.query = getNotesQuery();
  }

  Query getNotesQuery() =>
      notesRef.orderBy(FirebaseKey.timeCreated, descending: true).limit(10);

  @override
  Future<Result> create(Note note) async {
    //TODO check internet
    try {
      if (!note.isValid()) {
        return Result(
            err: FormatException(
          "Dữ liệu không hợp lệ",
        ));
      }

      DocumentReference currentDoc = this.notesRef.doc();
      // set emotion objects
      CollectionReference activityRef =
          currentDoc.collection(FirebaseKey.activities);
      WriteBatch batch = _firestore.batch();
      for (final emotion in note.activities) {
        batch.set(activityRef.doc(emotion.id), emotion.toJson());
      }
      await batch.commit();

      //Cập nhật danh sách lên server
      await currentDoc.set(note.toJson());

      // Cập nhật trường id
      note.id = currentDoc.id;

      return Result(data: note);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  @override
  Future<Result> delete(Note note) async {
    try {
      await notesRef.doc(note.id).delete().then((value) {
        print("OKAY");
      });
      WriteBatch batch = this._firestore.batch();
      for (final activity in note.activities)
        batch.delete(notesRef
            .doc(note.id)
            .collection(FirebaseKey.activities)
            .doc(activity.id));
      await batch.commit();

      return Result(data: "Okay");
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  @override
  Future<Result<Note>> get() {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Note>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Result<Note>> update(Note note) async {
    try {
      //Cập nhật
      await notesRef.doc(note.id).update(note.toJson());

      // Xóa tất cả activity hiện tại trong note
      final snapshot =
          await notesRef.doc(note.id).collection(FirebaseKey.activities).get();
      await Future.forEach(snapshot.docs, (QueryDocumentSnapshot e) async {
        await notesRef
            .doc(note.id)
            .collection(FirebaseKey.activities)
            .doc(e.id)
            .delete();
      });

      //Cập nhật activity mới
      WriteBatch activitiesBatch = _firestore.batch();
      for (final activity in note.activities) {
        activitiesBatch.set(
            notesRef
                .doc(note.id)
                .collection(FirebaseKey.activities)
                .doc(activity.id),
            activity.toJson());
      }
      await activitiesBatch.commit();

      return Result<Note>(data: note);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  @override
  Future<Result<List<Note>>> loadMore() async {
    List<Note> notes = [];

    try {
      if(query == null) query = getNotesQuery();

      if (lastDoc != null) query = query!.startAfterDocument(lastDoc!);

      List<QueryDocumentSnapshot> docs = (await query!.get()).docs;

      //save last doc for pagination purpose
      if (docs.isNotEmpty) this.lastDoc = docs.last;
      //TODO get activities
      docs.forEach((e) {
        Note quote = Note.fromJson(e.data() as Map<String, dynamic>)..id = e.id;
        notes.add(quote);
      });

      return Result<List<Note>>(data: notes, err: null);
    } catch (e) {
      return Result(err: Exception(e), data: null);
    }
  }

  clear() {
    this.query = null;
  }
}
