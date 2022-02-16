import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/app_data.dart';
import 'package:sophia_hub/provider/single_note_state_manager.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/repository/note_repository.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class NotesStateManager extends App
    with ChangeNotifier
    implements ReassembleHandler {
  List<SingleNoteManager> _notes = [];

  late NoteRepository repository;

  GlobalKey<AnimatedListState>? listKey;
  RemovedItemBuilder<SingleNoteManager>? removedItemBuilder;

  NotesStateManager({NoteRepository? repository}) {
    this.repository = repository ?? NoteFirebaseRepository();
  }

  List<SingleNoteManager> get notes => _notes;

  Future<bool> add({required Note note}) async => setAppState(() async {
        Result res = await repository.create(note);
        //Thêm note vào danh sách hiện tại
        if (res.isHasData) {
          int index = insertSorted(note);
          listKey?.currentState?.insertItem(index);
        }
        return res;
      });

  Future<bool> delete(SingleNoteManager manager) async => setAppState(() async {
        Note note = manager.note;
        Result res = await repository.delete(note);
        if (res.isHasData) {
          deleteSorted(note);
          int index = _notes.indexWhere((e) => e.note.id == note.id);

          //remove item after delete
          listKey!.currentState?.removeItem(index,
              (BuildContext context, Animation<double> animation) {
            return removedItemBuilder!(manager, context, animation);
          }, duration: Duration(seconds: 1));
        }

        return res;
      });

  Future<bool> update({required Note note}) async => setAppState(() async {
        int indexFound = _notes.indexWhere((other) => note.id == other.note.id);
        if (indexFound == -1) {
          return Result(err: Exception("Note không tồn tại"));
        }

        Result res = await repository.update(note);
        if (res.isHasData) {
          note = res.data as Note;
          deleteSorted(note);
          insertSorted(note);
        }
        return res;
      });

  Future<bool> loadMore() async => setAppState(() async {
        Result<List<Note>> res = await repository.loadMore();
        print(res.data);
        if (res.isHasData) {
          _notes.addAll((res.data as List<Note>).map((e) => SingleNoteManager(e)));
          notifyListeners();
        }
        return res;
      });

  clear() {
    (repository as NoteFirebaseRepository).clear();
    _notes.clear();
  }

  ///Logic methods

  //https://www.geeksforgeeks.org/search-insert-and-delete-in-a-sorted-array/
  int insertSorted(Note note) {
    //Thêm một note để giữ chỗ
    _notes.insert(0, SingleNoteManager(Note.empty()));
    int i;
    for (i = 1;
        (i < _notes.length &&
            _notes[i].note.timeCreated.isAfter(note.timeCreated));
        i++) _notes[i - 1] = _notes[i];

    _notes[i - 1] = SingleNoteManager(note);
    return (i - 1);
  }

  int deleteSorted(Note note) {
    int index = this._notes.indexWhere((e) => e.note.id == note.id);
    if (index == -1) {
      print("Không tồn tại");
    }
    this._notes.removeAt(index);
    return index;
  }

  @override
  void reassemble() {
  }

  @override
  void dispose() {
    super.dispose();
    this.appConnectionState.close();
  }
}
