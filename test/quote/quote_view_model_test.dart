import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/model/quote/quote_category.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

main() async {
  late FakeFirebaseFirestore fireStore;
  late QuoteViewModel viewModel;

  setUpAll(() async {
    fireStore = FakeFirebaseFirestore();

  });

  group("CRUD", () {
    setUp(() async {
      viewModel = QuoteViewModel(firestore: fireStore);
      await Future.forEach(
          List<Quote>.generate(10, (index) {
            return Quote(
                QuoteCategory.general,
              content: lorem(paragraphs: 2, words: 15),
            );
          }), (Quote quote) async {
        await fireStore.collection("quotes").doc().set(quote.toJson());
      });

      // final value = await fireStore.collection("quotes").get();
      // value.docs.forEach((snapshot) {
      //   print(snapshot.data());
      // });
    });

    test("Read all quotes", () async {
      await Future.forEach([1, 2, 3, 4], (_) async {
        await viewModel.loadQuotes();
        print(viewModel.quotes.length);
      });
      expectLater(viewModel.quotes.length, 10);
    });
  });
}
