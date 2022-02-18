import 'package:sophia_hub/model/result_container.dart';

import 'repository.dart';

abstract class NoteRepository<GenericNote> extends Repository<GenericNote>  {
  Future<Result<List<GenericNote>>> loadMore();
}
