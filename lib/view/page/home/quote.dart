import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/provider/quote_provider.dart';

class QuoteView extends StatefulWidget {
  @override
  _QuoteViewState createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
  PageController? _pageController;
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()..addListener(_scrollListener);
    Future.microtask(() {
      Provider.of<QuotesProvider>(context, listen: false).loadMore();
    });
  }

  @override
  void dispose() {
    _pageController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if(_pageController?.page == _pageController?.page?.roundToDouble()){
      setState(() {
        curIndex = _pageController?.page?.roundToDouble().toInt() ?? 0;
      });
    }
    if (_pageController?.position.extentAfter == 0) {
      print("loadmore");
      Provider.of<QuotesProvider>(context, listen: false).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    QuotesProvider provider = Provider.of<QuotesProvider>(context);
    Size size = MediaQuery.of(context).size;
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: () {
          return Colors.black;
          // int red = primary.red;
          // int green = primary.green;
          // int blue = primary.blue;
          // return Color.fromRGBO(
          //     red ~/ 2, green ~/ 2, blue ~/ 2, 0.6);
        }()),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                foregroundDecoration: BoxDecoration(color: () {
                  int red = primary.red;
                  int green = primary.green;
                  int blue = primary.blue;
                  return Color.fromRGBO(
                      red ~/ 2, green ~/ 2, blue ~/ 2, 0.6);
                }()),
                child: Builder(
                  builder: (BuildContext context) {
                    if(provider.quotes.length == 0){ return Container();}
                    return CachedNetworkImage(
                      imageUrl: provider.quotes[curIndex].imageUrl ??
                          "https://firebasestorage.googleapis.com/v0/b/small-habits-0812.appspot.com/o/astronaut%20(1).jpg?alt=media&token=92ff8444-d939-48f8-975c-cc2a67b25a9a",
                      fit: BoxFit.cover,
                      fadeOutDuration: Duration(milliseconds: 500),
                      useOldImageOnUrlChange: true,
                      errorWidget: (_,err,stackTrace){
                        return Image.asset("media/images/astronaut.jpg",fit: BoxFit.fill,);
                      },
                      placeholder: (context, url) {return Center(
                          child: Column(children: [
                            Icon(
                              FontAwesomeIcons.download,
                            ),
                            Text("Đang tải...")
                          ]));

                      },
                    ); },
                ),
              ),
            ),
            Positioned.fill(
                  child: PageView.builder(
            scrollDirection: Axis.vertical,
                  itemCount: provider.quotes.length,
                  controller: _pageController,
                  itemBuilder: (_, index) {
                    return Container(
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
                                      "${provider.quotes[index].content}",
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
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            "${provider.quotes[index].authorName ?? "Khuyết danh"}",
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
        ));
  }
}

