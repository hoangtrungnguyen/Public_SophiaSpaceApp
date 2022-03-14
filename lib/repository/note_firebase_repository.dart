import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_image.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/model/note/note_type.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_repository.dart';

import 'note_exception/note_exception.dart';

class NoteFirebaseRepository extends NoteRepository<GenericNote> {
  late FirebaseFirestore _firestore;

  get firestore => _firestore;

  late CollectionReference _notesRef;

  CollectionReference get notesRef => _notesRef;

  late Query _query;

  //Last doc for pagination purpose
  DocumentSnapshot? _lastDoc;

  NoteFirebaseRepository({FirebaseFirestore? firestore, FirebaseAuth? auth}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = auth ?? FirebaseAuth.instance;

    if (firebaseAuth.currentUser == null) return;
    _notesRef = _firestore
        .collection(FirebaseKey.users)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(FirebaseKey.notes);
    //set initial query
    this._query = getNotesQuery();
  }

  Query getNotesQuery() =>
      notesRef.orderBy(FirebaseKey.timeCreated, descending: true).limit(5);

  @override
  Future<Result> create(GenericNote note) async {
    try {
      if (!note.isValid()) {
        return Result(
            err: FormatException(
          "Dữ liệu không hợp lệ",
        ));
      }

      DocumentReference currentDoc = this.notesRef.doc(
        note.timeCreated.millisecondsSinceEpoch.toString()
      );

      //Nếu là note bình thường
      if (note is Note) {
        // TODO làm theo SDS

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
      // TODO làm theo SDS
      if (note is Note) {
      } else if (note is NoteImage) {
        //TODO delete images here
      }

      return Result(data: "Okay");
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  @override
  Future<Result<GenericNote>> getById(String id) async {
    try {
      final ref = notesRef.doc(id);

      final doc = await notesRef.doc(id).get();

      if(!doc.exists){
        return Result(err: NoteNotFoundException("Không tìm thấy"));
      }
      GenericNote? note;
      if(doc.get("type") == NoteType.regular.name){
        note = Note.fromJson(doc.data() as Map<String,dynamic>);
        note.id = doc.id;
      } else if (doc.get("type") == NoteType.image.name){

      }
      return Result(data: note);
    } on Exception catch (e) {
      return Result(err: e);
    }
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
      } else if (note is NoteImage) {
        //TODO update NoteImage here

      }

      return Result<GenericNote>(data: note);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  @override
  Future<Result<List<GenericNote>>> loadMore() async {
    List<GenericNote> notes = [];

    try {
      if (_lastDoc != null) _query = _query.startAfterDocument(_lastDoc!);

      List<QueryDocumentSnapshot> docs = (await _query.get()).docs;

      //save last doc for pagination purpose
      if (docs.isNotEmpty) _lastDoc = docs.last;

      docs.forEach((QueryDocumentSnapshot doc) {
        if (doc.get("type") == NoteType.regular.name.toLowerCase()) {
          Note note = Note.fromJson(doc.data() as Map<String, dynamic>)
            ..id = doc.id;
          notes.add(note);
        } else if (doc.get("type") == NoteType.image.name.toLowerCase()) {
          NoteImage noteImage = NoteImage()..id = doc.id;
          //TODO
        }
      });

      return Result<List<GenericNote>>(data: notes, err: null);
    } catch (e) {
      return Result(err: Exception(e), data: null);
    }
  }

  @override
  Future<void> refresh() async {
    _query = getNotesQuery();
  }
}
