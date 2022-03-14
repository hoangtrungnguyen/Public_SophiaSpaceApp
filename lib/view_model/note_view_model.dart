import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_firebase_repository.dart';
import 'package:sophia_hub/repository/note_repository.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class NotesViewModel extends BaseViewModel implements ReassembleHandler {
  List<SingleNoteViewModel> _notes = [];

  bool isRefreshing = false;

  bool isNoMoreNote = false;

  late NoteRepository repository;

  GlobalKey<AnimatedListState>? listKey;

  RemovedItemBuilder<SingleNoteViewModel>? removedItemBuilder;

  RemovedItemBuilder<SingleNoteViewModel>? clearanceItemBuilder;

  NotesViewModel({NoteRepository? repository}) {
    this.repository = repository ?? NoteFirebaseRepository();
  }

  List<SingleNoteViewModel> get notes => _notes;

  Future<bool> add({required GenericNote note}) async => setAppState(() async {
        Result res = await repository.create(note);
        //Thêm note vào danh sách hiện tại
        if (res.isHasData) {
          insertSorted(note);
        }
        return res;
      });

  Future<bool> delete(GenericNote singleNote) async => setAppState(() async {
        Result res = await repository.delete(singleNote);
        if (res.isHasData) {
          deleteSorted(singleNote);
          //remove item after delete
        }

        return res;
      });

  Future<bool> update({required GenericNote note}) async =>
      setAppState(() async {
        int indexFound = _notes.indexWhere((other) => note.id == other.note.id);
        if (indexFound == -1) {
          return Result(err: Exception("Note không tồn tại"));
        }

        Result res = await repository.update(note);
        if (res.isHasData) {
          deleteSorted(note);
          insertSorted(note);
        }
        return res;
      });

  Future<bool> loadMore() async => setAppState(() async {
        if (this.isNoMoreNote) {
          if (kDebugMode) print("No more note");
          return Result(data: "No more note");
        }

        Result<List<GenericNote>> res =
            (await repository.loadMore() as Result<List<GenericNote>>);

        if (res.isHasData && (res.data as List).length == 0) {
          this.isNoMoreNote = true;
        }

        if (res.isHasData && (res.data as List).length > 0) {
          List<GenericNote> list = (res.data as List<GenericNote>);
          for (int i = 0; i < list.length; i++) {
            insertSorted(list[i]);
          }
        }
        return res;
      });

  Future<bool> refresh({NoteRepository? repository}) async =>
      setAppState(() async {
        this.isRefreshing = true;
        refreshView();
        this.repository = repository ?? NoteFirebaseRepository();
        Result<List<GenericNote>> res =
            (await this.repository.loadMore() as Result<List<GenericNote>>);

        if (res.isHasData && (res.data as List).length > 0) {
          List<GenericNote> list = (res.data as List<GenericNote>);
          for (int i = 0; i < list.length; i++) {
            insertSorted(list[i]);
          }
        }
        await Future.delayed(Duration(seconds: 1));
        this.isNoMoreNote = false;
        this.isRefreshing = false;
        return res;
      });

  ///Logic methods

  //https://www.geeksforgeeks.org/search-insert-and-delete-in-a-sorted-array/
  int insertSorted(GenericNote note, {Duration? duration}) {
    if (_notes.contains(note)) {
      return -1;
    }

    //Thêm một note để giữ chỗ
    _notes.insert(0, SingleNoteViewModel(Note()));
    int i;
    for (i = 1;
        (i < _notes.length &&
            _notes[i].note.timeCreated.isAfter(note.timeCreated));
        i++) _notes[i - 1] = _notes[i];

    _notes[i - 1] = SingleNoteViewModel(note);
    listKey?.currentState
        ?.insertItem(i - 1, duration: duration ?? Duration(milliseconds: 500));
    return (i - 1);
  }

  int deleteSorted(GenericNote note, {Duration? duration}) {
    int index = this._notes.indexWhere((e) => e.note.id == note.id);
    if (index == -1) {
      print("Không tồn tại");
    }

    listKey?.currentState?.removeItem(index,
        (BuildContext context, Animation<double> animation) {
      return removedItemBuilder!(_notes[index], context, animation);
    }, duration: duration ?? Duration(seconds: 1));

    this._notes.removeAt(index);
    return index;
  }

  refreshView({Duration? duration}) {
    for (int i = _notes.length - 1; i >= 0; i--) {
      SingleNoteViewModel note = _notes[i];
      int index = this._notes.indexWhere((e) => e.note.id == note.note.id);
      if (index == -1) {
        print("Không tồn tại");
      }
      this._notes.removeAt(index);
      listKey?.currentState?.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return clearanceItemBuilder!(note, context, animation);
      }, duration: duration ?? Duration(seconds: 1));
    }
  }

  @override
  void reassemble() {
    refresh();
  }

  Future reload({NoteRepository? repository}) async {
    for (int i = _notes.length - 1; i >= 0; i--) {
      deleteSorted(_notes[i].note, duration: Duration(milliseconds: 50));
    }

    this.repository = repository ?? NoteFirebaseRepository();
    return await loadMore();
  }
}
