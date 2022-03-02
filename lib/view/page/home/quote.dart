import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view/page/home/quote_tab/quote_tab_share_btn.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

class QuoteView extends StatefulWidget {
  @override
  _QuoteViewState createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
  PageController? _pageController;
  int curIndex = 0;

  late GlobalKey _quoteTabViewStackKey;

  @override
  void initState() {
    super.initState();
    _quoteTabViewStackKey = GlobalKey();
    _pageController = PageController()..addListener(_scrollListener);
    Future.microtask(() {
      Provider.of<QuoteViewModel>(context, listen: false).loadQuotes();
    });
  }

  @override
  void dispose() {
    _pageController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_pageController?.page == _pageController?.page?.roundToDouble()) {
      setState(() {
        curIndex = _pageController?.page?.roundToDouble().toInt() ?? 0;
        // Provider.of<QuoteViewModel>(context, listen: false)
        //     .quotes[curIndex]
        //     .imageUrl;
      });
    }
    if (_pageController?.position.extentAfter == 0) {
      Provider.of<QuoteViewModel>(context, listen: false).loadQuotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    QuoteViewModel quoteState = Provider.of<QuoteViewModel>(context);
    Size size = MediaQuery.of(context).size;
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
              Container(
                foregroundDecoration:
                    BoxDecoration(color: primary.withOpacity(0.6)),
                child: Builder(
                  builder: (BuildContext context) {
                    if (quoteState.quotes.length == 0) {
                      return Container();
                    }
                    return CachedNetworkImage(
                      imageUrl: quoteState.quotes[curIndex].imageUrl ??
                          "https://firebasestorage.googleapis.com/v0/b/small-habits-0812.appspot.com/o/astronaut%20(1).jpg?alt=media&token=92ff8444-d939-48f8-975c-cc2a67b25a9a",
                      fit: BoxFit.cover,
                      fadeOutDuration: Duration(milliseconds: 500),
                      useOldImageOnUrlChange: true,
                      errorWidget: (_, err, stackTrace) => Image.asset(
                        "media/images/astronaut2.jpg",
                        fit: BoxFit.fill,
                      ),
                      placeholder: (context, url) => Center(
                          child: Column(children: [
                        Icon(FontAwesomeIcons.download),
                        Text("Đang tải...")
                      ])),
                    );
                  },
                ),
              ),

              // Text
              Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.35)),
                child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: quoteState.quotes.length,
                    controller: _pageController,
                    itemBuilder: (_, index) {
                      return SizedBox(
                          height: size.height,
                          width: size.width,
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
                                      Text(
                                        "${quoteState.quotes[index].content}",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 2,
                                            width: 20,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "${quoteState.quotes[index].authorName ?? "Khuyết danh"}",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            height: 2,
                                            width: 20,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ));
                    }),
              ),
            ],
          ),
        ),
        Align(
            alignment: Alignment(0, 0.75),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(children: [
                  Spacer(),
                  QuoteTabShareButton(
                    stackKey: _quoteTabViewStackKey,
                  )
                ]))),
      ],
    );
  }
}
