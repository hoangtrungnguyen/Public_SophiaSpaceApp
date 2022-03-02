import 'package:sophia_hub/model/result_container.dart';

import 'base_repository.dart';

abstract class Repository<T> extends BaseRepository{

  Future<Result<List<T>>> getAll();

  Future<Result<T>> getById(String id);

  Future<Result> delete(T element);

  Future<Result> update(T element);

  Future<Result> create(T element);

}
