import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/repository.dart';

abstract class QuoteRepository extends Repository<Quote> {
  Future<Result<List<Quote>>> loadQuote();

  Future<Result> addToFavourite(Quote quote);

  @override
  Future<Result> add(Quote element) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Result> create(Quote quote) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result> delete(element) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<Quote>> getById(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Quote>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Result> update(element) {
    // TODO: implement update
    throw UnimplementedError();
  }
}