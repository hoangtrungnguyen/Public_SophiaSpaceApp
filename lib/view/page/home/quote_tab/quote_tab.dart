import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/view/animation/route_change_anim.dart';
import 'package:sophia_hub/view/page/quote/quote_hero_widget.dart';
import 'package:sophia_hub/view/page/quote/quote_shared_page.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

import 'quote_tab_image.dart';
import 'quote_tab_page_view.dart';

class QuoteView extends StatefulWidget {
  @override
  _QuoteViewState createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
  PageController? _pageController;

  late GlobalKey _quoteTabViewStackKey;

  @override
  void initState() {
    super.initState();
    _quoteTabViewStackKey = GlobalKey();
    _pageController = PageController(
      initialPage: Provider.of<QuoteViewModel>(context, listen: false).curIndex
    );
    Provider.of<QuoteViewModel>(context, listen: false).pageController = _pageController;
    Future.microtask(() {
      Provider.of<QuoteViewModel>(context, listen: false).loadQuotes();
    });
  }


  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          key: _quoteTabViewStackKey,
          child: Stack(
            fit: StackFit.expand,
            children: [
              //Image
                  QuoteTabImage(),
              // Text
                 QuoteTabPageView(),

            ],
          ),
        ),
        Align(
            alignment: Alignment(0, 0.75),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(children: [
                  Spacer(),
                  SizedBox(
                      height: 40,
                      width: 40,
                      child: TextButton(
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets?>(
                                EdgeInsets.zero),
                            backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.white.withOpacity(0.3),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder?>(
                                continuousRectangleBorder as OutlinedBorder)),
                        onPressed: () {

                          Navigator.of(context).push(
                              RouteAnimation.buildDefaultRouteTransition(
                                  QuoteSharePage.view(Provider.of<QuoteViewModel>(context, listen: false)), null
                              )
                          );
                        },
                      ))
                ]))),
      ],
    );
  }
}



