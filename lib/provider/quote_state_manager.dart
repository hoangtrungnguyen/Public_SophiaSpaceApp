import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sophia_hub/constant/app_connection_state.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/app_data.dart';
import 'package:sophia_hub/repository/quote_fire_store_repository.dart';

class QuoteStateManager extends App with ChangeNotifier{
  List<Quote> quotes = [];

  late QuoteFireStoreRepository quoteFirebaseRepository;

  QuoteStateManager({FirebaseFirestore? firestore}){
    quoteFirebaseRepository = QuoteFireStoreRepository(firestore: firestore);
  }

  Future<bool> loadQuotes({String? category}) async {
    return setAppState(() async {
      Result<List<Quote>> result = await quoteFirebaseRepository.loadQuote();
      if(result.isHasData) {
        quotes.addAll(result.data);
        notifyListeners();
      }
      return result;
    });
  }

  Future<bool> addQuoteToFav(Quote quote) async {
      return setAppState(() async {
        Result result = await quoteFirebaseRepository.addToFavourite(quote);
        notifyListeners();
        return result;
      });

  }
}
