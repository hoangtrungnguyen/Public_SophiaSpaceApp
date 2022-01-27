import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/app_data.dart';
import 'package:sophia_hub/provider/connection_state.dart';

class NotesPublisher extends App
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

  NotesPublisher({
    required this.fireStore,
    required this.auth,
    this.isTesting = false,
  }) {
    config();
  }

  /// [addNote] adding a note
  /// This function will add note to firebase storage
  /// This function also checks initial input
  /// Function trả về index đã của note được thêm vào
  Future<Result> addNote({required Note note}) async {
    try {
      if (!note.isValid()) {
        return Result(err: FormatException("Dữ liệu không hợp lệ"));
      }

      DocumentReference currentDoc = this.notesRef.doc();

      // set emotion objects
      CollectionReference activityRef =
          currentDoc.collection(FirebaseKey.activities);
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
      int index = insertSorted(note);
      return Result(data: {"addedIndex": index}, err: null);
    } catch (e) {
      print("Failed to add user: $e");
      return Result(data: null, err: Exception("Failed to add user: $e"));
    }
  }

  //https://www.geeksforgeeks.org/search-insert-and-delete-in-a-sorted-array/
  int insertSorted(Note note) {
    //Thêm một note để giữ chỗ
    notes.insert(0, Note(emotionPoint: 0));
    int i;
    for (i = 1;
        (i < notes.length && notes[i].timeCreated.isAfter(note.timeCreated));
        i++) notes[i - 1] = notes[i];
    notes[i - 1] = note;
    return (i - 1);
  }

  int deleteSorted(Note note) {
    int index = this.notes.indexWhere((e) => e.id == note.id);
    if (index == -1) {
      print("Không tồn tại");
    }
    this.notes.removeAt(index);
    return index;
  }

  /// [ DateTime, Note, Note, Note, Note, DateTime
  ///
  ///
  List<Object> group() {
    if (notes.isEmpty) return [];

    List<Object> result = [];
    Note cur = notes[0];
    DateTime curDateTime = DateTime(
      cur.timeCreated.year,
      cur.timeCreated.month,
      cur.timeCreated.day,
    );
    result.add(curDateTime);
    result.add(cur);

    for (int i = 1; i < notes.length; i++) {
      DateTime thisNoteDateTime = DateTime(
        notes[i].timeCreated.year,
        notes[i].timeCreated.month,
        notes[i].timeCreated.day,
      );
      if (curDateTime.isAtSameMomentAs(thisNoteDateTime)) {
        result.add(notes[i]);
      } else {
        curDateTime = thisNoteDateTime;
        result.add(curDateTime);
        result.add(notes[i]);
      }
    }

    return result;
  }

  Query getNotesQuery() =>
      notesRef.orderBy('time_created', descending: true).limit(10);

  Stream<int> noteIndexStream = Stream.empty();

  Stream<int> loadMoreNotes() async* {
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

      for (DocumentSnapshot doc in docs) {
        Note note = Note.fromJson(doc.data() as Map<String, dynamic>);
        note.id = doc.id;

        note.activities.addAll((await notesRef
                .doc(doc.id)
                .collection(FirebaseKey.activities)
                .get())
            .docs
            .map((e) {
          return Activity.fromJson(e.data())
            ..icon =
                activities.firstWhere((element) => element.id == e.id).icon;
        }));

        //Kiểm tra note này đã tồn tại trong danh sách chưa?
        if (!this.notes.contains(note)) yield insertSorted(note);
      }
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
    try {
      this.isLoading = true;
      notifyListeners();

      int indexFound = this.notes.indexWhere((other) => note.id == other.id);
      if (indexFound == -1) {
        print("Note không tồn tại");
        return Result(err: Exception("Note không tồn tại"));
      } else {
        this.notes[indexFound] = note;
      }

      Note copied = note.copy();
      int indexDeleted = deleteSorted(note);
      int indexAdded = insertSorted(copied);

      //Cập nhật object cảm xúc
      await notesRef.doc(note.id).update(note.toJson()).then((value) async {
        WriteBatch batch = this.fireStore.batch();
        for (final activity in note.activities) {
          batch.set(
              notesRef
                  .doc(note.id)
                  .collection(FirebaseKey.activities)
                  .doc(activity.id),
              activity.toJson());
        }
        await batch.commit();
      });

      return Result(data: {
        "deletedIndex": indexDeleted,
        "addedIndex": indexAdded,
      });
    } on Exception catch (e) {
      return Result(err: e);
    } finally {
      notifyListeners();
    }
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

  Future<Result> delete(Note note) async {
    try {
      await notesRef.doc(note.id).delete().then((value) {
        print("OKAY");
      });
      WriteBatch batch = this.fireStore.batch();
      for (final activity in note.activities)
        batch.delete(notesRef
            .doc(note.id)
            .collection(FirebaseKey.activities)
            .doc(activity.id));
      await batch.commit();
      int index = deleteSorted(note);
      return Result(data: {"deletedIndex": index, "note": note});
    } catch (e) {
      return Result(err: Exception("Lỗi, thử lại sau"));
    } finally {
      notifyListeners();
    }
  }

  @override
  void reassemble() {
    // print("HotReload ${this.notes}");
  }
}
