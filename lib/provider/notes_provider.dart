import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/emotion.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/app_data.dart';
import 'dart:collection';

class NotesProvider extends App implements ReassembleHandler {
  final isTesting;
  List<Note> notes = [];

  //Không thể null
  late CollectionReference notesRef;
  Query? notesQuery;
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

      //Cập nhật danh sách lên server
      await currentDoc.set(note.toJson());

      //Cập nhật trường id
      note.id = currentDoc.id;

      //Thêm note vào danh sách hiện tại
      this.notes.add(note);
      //Sắp xếp lại danh sách theo thời gian tạo
      quickSort(notes, 0, notes.length - 1);

      return Result(data: "OK", err: null);
    } catch (e) {
      print("Failed to add user: $e");
      return Result(data: null, err: Exception("Failed to add user: $e"));
    }
  }

  ///
  Query getNotesQuery() => notesRef.orderBy('time_created').limit(10);

  loadMoreNotes() async {
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
      note.emotions.addAll(
          (await notesRef.doc(e.id).collection('emotions').get()).docs.map((e) {
        return Emotion.fromJson(e.data())
          ..icon = emotions.firstWhere((element) => element.id == e.id).icon;
      }));

      //Kiểm tra note này đã tồn tại trong danh sách chưa?
      if (!this.notes.contains(note)) this.notes.add(note);
    });
    notifyListeners();
  }

  //Cập nhật danh sách và vị trí của phần từ Note vừa được thêm vào và sắp xếp
  // Gọi hàm này sau mỗi lần thêm, sửa danh sách
  updateNote(Note note) async {
    if (!this.notes.contains(note))
      print("Note không tồn tại");
    else {
      int i = this.notes.indexOf(note);
      this.notes[i] = note;
    }

    //Sắp xếp lại danh sách theo thời gian tạo
    quickSort(notes, 0, notes.length - 1);

    notesRef.doc(note.id).update(note.toJson()).then((value) async {
      WriteBatch batch = this.fireStore.batch();
      for (final emotion in note.emotions) {
        batch.set(notesRef.doc(note.id).collection('emotions').doc(emotion.id),
            emotion.toJson());
      }
      await batch.commit();
    });
    notifyListeners();
  }

  ///hàm [quickSort] sắp xếp lại danh sách theo thời gian tạo
  ///
  /* low  --> Starting index,  high  --> Ending index */
  quickSort(List<Note> arr, int low, int high) {
    if (low < high) {
      /* pi is partitioning index, arr[pi] is now
           at right place */
      int pi = partition(arr, low, high);

      quickSort(arr, low, pi - 1); // Before pi
      quickSort(arr, pi + 1, high); // After pi
    }
  }

  /* This function takes last element as pivot, places
   the pivot element at its correct position in sorted
    array, and places all smaller (smaller than pivot)
   to left of pivot and all greater elements to right
   of pivot */
  partition(List<Note> array, int low, int high) {
    // pivot (Element to be placed at right position)
    Note pivot = array[high];

    int i = (low - 1); // Index of smaller element and indicates the
    // right position of pivot found so far

    for (int j = low; j <= high - 1; j++) {
      // If current element is smaller than the pivot
      if (array[j].timeCreated.isAfter(pivot.timeCreated)) {
        i++; // increment index of smaller element
        // swap arr[i] and arr[j]
        Note note = array[i];
        array[i] = array[j];
        array[j] = note;
      }
    }
    // swap arr[i + 1] and arr[high])
    Note note = array[i + 1];
    array[i + 1] = array[high];
    array[high] = note;
    return (i + 1);
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
