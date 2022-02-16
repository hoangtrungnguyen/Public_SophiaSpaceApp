import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';

import 'repository.dart';

abstract class NoteRepository extends Repository<Note> {
  Future<Result<List<Note>>> loadMore();
}
