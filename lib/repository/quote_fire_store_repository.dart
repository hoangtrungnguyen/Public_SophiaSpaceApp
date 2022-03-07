import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/model/quote/quote_category.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/quote_repository.dart';

class QuoteFireStoreRepository extends QuoteRepository {

  late CollectionReference quotesRef;
  late FirebaseFirestore fireStore;

  late Query _query;
  //Last doc for pagination purpose
  DocumentSnapshot? _lastDoc;

  /// Constructor has [firestore] to make this class testable
  QuoteFireStoreRepository({FirebaseFirestore? firestore}) {
    // Using app firebase as default option
    this.fireStore = firestore ?? FirebaseFirestore.instance;
    this.quotesRef = this.fireStore.collection(FirebaseKey.quotes);
    this._query = initialQuery();
  }


  @override
  Future<Result> addToFavourite(Quote quote)async {
    return Result(data: "",err: null);
  }

  @override
  Future<Result<List<Quote>>> loadQuote() async {
    List<Quote> quotes = [];

    try {

      if (_lastDoc != null )
        _query = _query.startAfterDocument(_lastDoc!);

      List<QueryDocumentSnapshot> docs = (await _query.get()).docs;

      //save last doc for pagination purpose
      if (docs.isNotEmpty) this._lastDoc = docs.last;

      docs.forEach((e){
        Quote quote = Quote.fromJson(e.data() as Map<String, dynamic>)..id = e.id;
        quotes.add(quote);
      });

      return Result<List<Quote>>(data: quotes,err: null);
    } catch (e) {
      return Result(err: Exception(e), data: null);
    }
  }

  Query initialQuery() => quotesRef.where(FirebaseKey.category,isEqualTo: QuoteCategory.general.name);

  clear() {}
}
