import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view/page/quote/quote_hero_widget.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

import 'quote_tab_page_view_single.dart';

class QuoteTabPageView extends StatelessWidget {
  const QuoteTabPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color primary = Theme.of(context).colorScheme.primary;

    return Consumer<QuoteViewModel>(
      builder: (context, quoteState,child){
        return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: quoteState.quotes.length,
            controller: Provider.of<QuoteViewModel>(context, listen: false).pageController,
            itemBuilder: (_, index) {
              return QuoteTabPageViewSingle(quote: quoteState.quotes[index],);
            });
      },
    );
  }
}