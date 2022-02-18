import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/repository/note_repository.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';
import 'package:sophia_hub/view_model/single_note_view_model.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class NotesViewModel extends BaseViewModel implements ReassembleHandler {
  List<SingleNoteViewModel> _notes = [];

  late NoteRepository repository;

  GlobalKey<AnimatedListState>? listKey;
  RemovedItemBuilder<SingleNoteViewModel>? removedItemBuilder;

  NotesViewModel({NoteRepository? repository}) {
    this.repository = repository ?? NoteFirebaseRepository();
  }

  List<SingleNoteViewModel> get notes => _notes;

  Future<bool> add({required GenericNote note}) async => setAppState(() async {
        Result res = await repository.create(note);
        //Thêm note vào danh sách hiện tại
        if (res.isHasData) {
          int index = insertSorted(note);
          listKey?.currentState?.insertItem(index);
        }
        return res;
      });

  Future<bool> delete(SingleNoteViewModel manager) async =>
      setAppState(() async {
        Result res = await repository.delete(manager.note);
        if (res.isHasData) {
          deleteSorted(manager.note);
          int index = _notes.indexWhere((e) => e.note.id == manager.note.id);

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
        Result<List<GenericNote>> res = (await repository.loadMore() as Result<List<GenericNote>>);
        if (res.isHasData) {
          _notes.addAll(
              (res.data as List<GenericNote>).map((e) => SingleNoteViewModel(e)));
        }
        return res;
      });

  clear() {
    (repository as NoteFirebaseRepository).clear();
    _notes.clear();
  }

  ///Logic methods

  //https://www.geeksforgeeks.org/search-insert-and-delete-in-a-sorted-array/
  int insertSorted(GenericNote note) {
    //Thêm một note để giữ chỗ
    _notes.insert(0, SingleNoteViewModel(Note()));
    int i;
    for (i = 1;
        (i < _notes.length &&
            _notes[i].note.timeCreated.isAfter(note.timeCreated));
        i++) _notes[i - 1] = _notes[i];

    _notes[i - 1] = SingleNoteViewModel(note);
    return (i - 1);
  }

  int deleteSorted(GenericNote note) {
    int index = this._notes.indexWhere((e) => e.note.id == note.id);
    if (index == -1) {
      print("Không tồn tại");
    }
    this._notes.removeAt(index);
    return index;
  }

  @override
  void reassemble() {
    loadMore();
  }
}
