import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_image.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_type.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_repository.dart';
import 'package:sophia_hub/view/page/home/notes/image_note.dart';

class NoteFirebaseRepository extends NoteRepository<GenericNote> {
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
  Future<Result> create(GenericNote note) async {
    try {
      if (!note.isValid()) {
        return Result(
            err: FormatException(
              "Dữ liệu không hợp lệ",
            ));
      }

      DocumentReference currentDoc = this.notesRef.doc();

      //Nếu là note bình thường
      if (note is Note) {
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

      } else if (note is NoteImage) {
        //TODO uploadImages here
        // Step 01: upload image from uri
        // Step 02: set image urls
      }

      note.id = currentDoc.id;

      return Result(data: note);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  @override
  Future<Result> delete(GenericNote note) async {
    try {
      await notesRef.doc(note.id).delete();

      if (note is Note) {
        WriteBatch batch = this._firestore.batch();
        for (final activity in note.activities)
          batch.delete(notesRef
              .doc(note.id)
              .collection(FirebaseKey.activities)
              .doc(activity.id));
        await batch.commit();
      } else if (note is NoteImage) {
        //TODO delete images here
      }

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
  Future<Result<GenericNote>> update(GenericNote note) async {
    try {
      //Cập nhật

      if (note is Note) {
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
      } else if (note is NoteImage) {
        //TODO update NoteImage here

      }

      return Result<GenericNote>(data: note);
      return Result(data: Note());
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  @override
  Future<Result<List<GenericNote>>> loadMore() async {
    List<GenericNote> notes = [];

    try {
      if (query == null) query = getNotesQuery();

      if (lastDoc != null) query = query!.startAfterDocument(lastDoc!);

      List<QueryDocumentSnapshot> docs = (await query!.get()).docs;

      //save last doc for pagination purpose
      if (docs.isNotEmpty) this.lastDoc = docs.last;


      await Future.forEach(docs, (QueryDocumentSnapshot doc) async {
        if (doc.get("type") == NoteType.REGULAR.name.toLowerCase()) {
          Note note = Note.fromJson(doc.data() as Map<String, dynamic>)
            ..id = doc.id;

            final listActivity =
            await notesRef.doc(doc.id).collection(FirebaseKey.activities).get();
            note.activities.addAll((listActivity).docs
                .map((e) => Activity.fromJson(e.data())
                ..icon =
                    activities
                        .firstWhere((element) => element.id == e.id)
                        .icon));

          notes.add(note);
        } else if (doc.get("type") == NoteType.IMAGE.name.toLowerCase()) {
          NoteImage noteImage = NoteImage()
            ..id = doc.id;
          //TODO
        }

      });

      return Result<List<GenericNote>>(data: notes, err: null);
    } catch (e) {
      return Result(err: Exception(e), data: null);
    }
  }

  clear() {
    this.query = null;
  }
}
