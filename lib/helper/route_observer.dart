import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:sophia_hub/view/base_container.dart';

//https://medium.com/flutter-community/flutter-navigator-middleware-part-2-middleware-service-class-c9035f4fff68
class AppMiddleware<R extends Route<dynamic>> extends RouteObserver<R> {
  final bool enableLogger;

  final List<Route<dynamic>> _stack;

  //create clone list from stack
  List<R> get stack => List<R>.from(_stack);

  AppMiddleware({this.enableLogger = kDebugMode}) : _stack = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    _logget('{didPush} \n route: $route \n previousRoute: $previousRoute');
    _stack.remove(route);
    _logStack();


    // if(previousRoute?.settings.name == BaseContainer.nameRoute) {
    //   if(previousRoute?.settings)
    // };
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _logget('{didPush} \n route: $route \n previousRoute: $previousRoute');
    _stack.remove(route);
    _logStack();

    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _logget('{didPush} \n route: $newRoute \n previousRoute: $oldRoute');
    if (oldRoute != null && newRoute != null && _stack.indexOf(oldRoute) >= 0) {
      final oldItemIndex = _stack.indexOf(oldRoute);
      _stack[oldItemIndex] = newRoute;
    }
    _logStack();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _logget('{didPush} \n route: $route \n previousRoute: $previousRoute');
    stack.remove(route);
    _logStack();
    super.didRemove(route, previousRoute);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    _logget('{didPush} \n route: $route \n previousRoute: $previousRoute');
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    _logget('{didStopUserGesture}');
    super.didStopUserGesture();
  }

  void _logget(String content) {
    if (enableLogger) {
      log(content);
    }
  }

  void _logStack() {
    final mappedStack = _stack.map((Route route) => route.settings.name).toList();
    _logget('Navigator stack: $mappedStack');
  }
}
