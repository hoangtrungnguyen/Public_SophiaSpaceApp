import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sophia_hub/view/page/home_container.dart';

import 'widget/drawer_menu.dart';

class BaseContainer extends StatefulWidget {
  static const String nameRoute = "/";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return BaseContainer();
    });
  }

  const
  BaseContainer();

  @override
  _BaseContainerState createState() => _BaseContainerState();
}

class _BaseContainerState extends State<BaseContainer> with SingleTickerProviderStateMixin{
  late AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    animController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool canBeDragged = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double maxSlide = size.width * 2.5 / 3;
    return GestureDetector(
      onHorizontalDragStart: (details) {
        bool isDragFromLeft = animController.isDismissed &&
            details.globalPosition.dx < /*size.width - size.width * 0.89442*/
                size.width - maxSlide;
        bool isDragFromRight = animController.isCompleted &&
            details.globalPosition.dx > /*size.width - size.width * 0.89442*/
                size.width - maxSlide;
        canBeDragged = isDragFromLeft || isDragFromRight;
      },
      onHorizontalDragUpdate: (details) {
        if (canBeDragged) {
          double delta = details.primaryDelta! /
              (/*size.width - size.width * 0.89442*/ maxSlide);
          if (animController.value <= 1) animController.value += delta;
        }
      },
      onHorizontalDragEnd: (details) {
        if (animController.isCompleted || animController.isDismissed) return;
        if (animController.value < 0.5)
          animController.reverse();
        else
          animController.forward();
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white.withOpacity(0.25),
              )),

          //Drawer Menu
          AnimatedBuilder(
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(maxSlide * (animController.value - 1), 0),
                  child: Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 * (1 - animController.value)),
                    child: child,
                  ),
                );
              },
              animation: animController,
              child: Container(
                width: maxSlide,
                height: size.height,
                child: DrawerMenu(),
              )),

          // Home
          AnimatedBuilder(
            animation: animController,
            builder: (BuildContext context, Widget? child) {
//              double scale = 1 - (animController.value * 0.2);
//              double slide = maxSlide * animController.value;
              return Transform.translate(
                offset: Offset(maxSlide * animController.value, 0),
                child: Transform(
                  transform: Matrix4.identity()
//                  ..translate(slide)
//                  ..scale(scale)
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(-math.pi * animController.value / 2),
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    child: child,
//                        BorderProvider.rounded(all: 16 * animController.value),
                  ),
                ),
              );
            },
            child: HomeContainer(),
          ),
          //animated AppBar
          AnimatedBuilder(
            animation: animController,
            builder: (BuildContext context, Widget? child) {
              return Transform.translate(
                  offset: Offset(maxSlide * animController.value, 0),
                  child: child);
            },
            child: SizedBox(
              height: 92,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.menu
                    ),
                    onPressed: () {
                      if (animController.status == AnimationStatus.completed)
                        animController.reverse();
                      if (animController.status == AnimationStatus.dismissed)
                        animController.forward();
                    }),
                title: Text("Small Habits",style: TextStyle(color: Colors.black),),
                centerTitle: true,
                actions: <Widget>[],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
