import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/color_helper.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/view/page/quote/quote_hero_widget.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

class QuoteTabImage extends StatelessWidget {

  final Quote? quote;
  const QuoteTabImage({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;

    return QuoteHero(
      tag: 'quote-image',
      child: Container(
          foregroundDecoration:
          ShapeDecoration(color: shadingForegroundColor(primary),
              shape: continuousRectangleBorder),
          child: Builder(
            builder: (BuildContext context) {
              if (quote == null) {
                return Container();
              }
              return CachedNetworkImage(
                imageUrl: (){
                  String holderImg = 'https://images.unsplash.com/photo-1531306728370-e2ebd9d7bb99?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&q=80';
                  String imgUrl = quote?.imageUrl ?? holderImg;
                  return imgUrl.isEmpty ? holderImg : imgUrl;
                }(),
                imageBuilder: (context, imageProvider){
                  return Container(
                    decoration: ShapeDecoration(
                      shape: continuousRectangleBorder,
                      image: DecorationImage(image: imageProvider,
                          fit: BoxFit.cover),
                    ),
                  );
                },
                fit: BoxFit.cover,
                fadeOutDuration: Duration(milliseconds: 500),
                useOldImageOnUrlChange: true,
                errorWidget: (_, err, stackTrace) => Image.asset(
                  "media/images/astronaut2.jpg",
                  fit: BoxFit.fill,
                ),
                placeholder: (context, url) => Center(
                    child: AnimatedLoadingIcon()),
              );
            },
          ))
    );
  }
}