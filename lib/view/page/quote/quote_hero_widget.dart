import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';

class QuoteHero extends Hero {
  QuoteHero({
    Key? key,
    required Object tag,
    required Widget child,
  }) : super(
          placeholderBuilder: (
            BuildContext context,
            Size heroSize,
            Widget child,
          ) {
            return ChangeNotifierProvider.value(
              value: Provider.of<QuoteViewModel>(context, listen: false),
              child: child,
            );
          },
    flightShuttleBuilder: (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            final Hero toHero = toHeroContext.widget as Hero;

            return ChangeNotifierProvider.value(
              value: Provider.of<QuoteViewModel>(fromHeroContext, listen: false),
              child: toHero.child,
            );
          },
          tag: tag,
          child: child,
        ) {}
}
