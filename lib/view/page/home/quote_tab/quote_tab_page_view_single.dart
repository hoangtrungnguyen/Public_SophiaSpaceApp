import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sophia_hub/model/author.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sophia_hub/view/page/quote/quote_hero_widget.dart';

class QuoteTabPageViewSingle extends StatelessWidget {
  final Quote quote;

  const QuoteTabPageViewSingle({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color primary = Theme.of(context).colorScheme.primary;

    return QuoteHero(
      tag:'${quote.id}',
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0.75, -0.15),
            child: Icon(
              FontAwesomeIcons.quoteRight,
              color: primary.withOpacity(0.8),
              size: 80,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    "${quote.content}",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white),
                    minFontSize: 14,
                    stepGranularity: 7,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                      (){

                    Author? author = quote.author;
                    bool isEmpty = author == null || author.name.isEmpty;

                    Widget divider = Container(
                      height: 2,
                      width: 20,
                      color: Colors.white,
                    );

                    Widget authorWidget = Text(
                      ' ${author?.name ?? '' } ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.white),
                    );

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isEmpty ? SizedBox() : divider,
                        authorWidget,
                        isEmpty ? SizedBox() : divider,
                      ],);
                  }(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}