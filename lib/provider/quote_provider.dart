import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/provider/app_data.dart';

class QuotesProvider extends App implements ReassembleHandler {
  final bool isTesting;
  List<Quote> quotes = [];

  //Không thể null
  late CollectionReference quotesRef;
  Query? query;
  late FirebaseFirestore fireStore;

  //Save the last doc for pagination purpose
  DocumentSnapshot? lastDoc;

  QuotesProvider({
    required this.fireStore,
    this.isTesting = false,
  }) {
    this.quotesRef = fireStore
        .collection(FirebaseKey.quotes);

    this.query = getQuery();
  }

  Query getQuery() => quotesRef.limit(3);

  loadMore() async {
    if (this.query == null) this.query = getQuery();

    if (quotes.isNotEmpty && lastDoc != null && query != null)
      query = query!.startAfterDocument(lastDoc!);

    QuerySnapshot querySnapshot = await query!.get();

    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    if (docs.isNotEmpty) this.lastDoc = docs.last;

    await Future.forEach<QueryDocumentSnapshot>(docs, (e) async {
      Quote quote = Quote.fromJson(e.data() as Map<String, dynamic>);
      quote.id = e.id;

      //Kiểm tra note này đã tồn tại trong danh sách chưa?
      if (!this.quotes.contains(quote)) this.quotes.add(quote);
    });
    notifyListeners();
  }

  @override
  void reassemble() {
    print("hot reload");
  }
}
