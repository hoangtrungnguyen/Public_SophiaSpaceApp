import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/quote_fire_store_repository.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';

class QuoteViewModel extends BaseViewModel {
  PageController? _pageController;

  PageController get pageController => _pageController!;

  set pageController(PageController? pageController) {
    _pageController = pageController;
    _pageController!.addListener(_scrollListener);
  }

  int _curIndex = 0;

  int get curIndex => _curIndex;

  set curIndex(int i) {
    _curIndex = i;
    curQuote = quotes[i];
    if (kDebugMode) {
      print(curQuote);
    }
    notifyListeners();
  }

  Quote? curQuote;

  List<Quote> quotes = [];

  late QuoteFireStoreRepository quoteFirebaseRepository;

  QuoteViewModel({FirebaseFirestore? firestore}) {
    quoteFirebaseRepository = QuoteFireStoreRepository(firestore: firestore);
  }

  Future<bool> loadQuotes({String? category}) async => setAppState(() async {
        if (quotes.isNotEmpty) return Result(data: "ok");
        Result<List<Quote>> result = await quoteFirebaseRepository.loadQuote();
        if (result.isHasData) {
          quotes.addAll(result.data);
          quotes.shuffle();
          curQuote = quotes[curIndex];
        }
        return result;
      });

  Future<bool> addQuoteToFav(Quote quote) async => setAppState(() async {
        Result result = await quoteFirebaseRepository.addToFavourite(quote);
        return result;
      });

  void _scrollListener() {
    if (_pageController?.page == _pageController?.page?.roundToDouble()) {
      curIndex = _pageController?.page?.roundToDouble().toInt() ?? 0;
    }
    if (_pageController?.position.extentAfter == 0) {
      // Provider.of<QuoteViewModel>(context, listen: false).loadQuotes();
    }
  }





  @override
  void dispose() {
    super.dispose();
    _pageController?.removeListener(_scrollListener);
  }
}
