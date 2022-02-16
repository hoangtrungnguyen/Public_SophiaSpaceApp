import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/note_repository.dart';

class NoteDatabaseRepository extends NoteRepository{
  @override
  Future<Result> create(Note note) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result> delete(Note element) {
    // TODO: implement delete
    throw UnimplementedError();
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
  Future<Result> update(Note element) {
    // TODO: implement update
    throw UnimplementedError();
  }


  @override
  loadMore() {
    // TODO: implement loadMore
    throw UnimplementedError();
  }


}