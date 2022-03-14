import 'package:flutter/material.dart';

class RouteAnimation {
  static PageRoute noneAnimation(Widget page, RouteSettings? settings) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 50),
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      maintainState: true,
    );
  }

  static PageRouteBuilder buildDefaultRouteTransition(
      Widget page, RouteSettings? settings) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      maintainState: true,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0);
        var tweenScale = Tween(begin: 1.3, end: 1.0);

        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return ScaleTransition(
          scale: tweenScale.animate(curvedAnimation),
          child: FadeTransition(
            opacity: tween.animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder getCreateNoteRouteTransition(
      Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400),
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Size screenSize = MediaQuery.of(
          context,
        ).size;
        // print("${screenSize.width}:${screenSize.height}");
        var tween = Tween<Offset>(begin: Offset(1.5, 0), end: Offset.zero);

        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
