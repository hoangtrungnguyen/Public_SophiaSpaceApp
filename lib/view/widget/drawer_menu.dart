import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu>
    with SingleTickerProviderStateMixin {
  Color endValue = Colors.black.withOpacity(0.8);
  Color beginColor = Colors.white;
  AnimationController controller;
  Animation<Color> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    animation =
        ColorTween(begin: beginColor, end: endValue).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: AnimatedBuilder(
          builder: (BuildContext context, Widget child) {
            return Container(
              color: animation.value,
              child: child,
            );
          },
          animation: animation,
          child: Container(child: Text("Drawer Menu"),),
        ),
      ),
    );
  }
}

