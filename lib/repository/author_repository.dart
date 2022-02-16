import 'package:sophia_hub/model/author.dart';
import 'package:sophia_hub/model/result_container.dart';

abstract class AuthorRepository {
  Future<Result<List<Author>>> loadAuthors();

  Future<Result> addAuthorToFavourite();
}
