import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/sophia_hub_app.dart';
import 'package:sophia_hub/view/page/home_container.dart';
import 'package:sophia_hub/view_model/ui_logic.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/drawer_menu.dart';

class BaseContainer extends StatefulWidget {
  static const String nameRoute = "/";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return BaseContainer();
    });
  }

  const BaseContainer();

  @override
  _BaseContainerState createState() => _BaseContainerState();
}

class _BaseContainerState extends State<BaseContainer>
    with SingleTickerProviderStateMixin {
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
    Color primary = Theme.of(context).colorScheme.primary;
    return WillPopScope(
      onWillPop: () async {
        // if(Provider.of<UILogic>(context,listen: false).homePageIndex == 0){
        //   return true;
        // }
        // return false;
        return true;
      },
      child: GestureDetector(
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
            Positioned.fill(child: Background()),

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
            Consumer<UILogic>(
              builder: (_, value, child) {
                //Index =1 là quote view
                return Visibility(
                    visible: value.homePageIndex != 1, child: child!);
              },
              child: AnimatedBuilder(
                animation: animController,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                      offset: Offset(maxSlide * animController.value, 0),
                      child: SizedBox(
                        height: 92,
                        child: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                              icon: Icon(Icons.menu_rounded,
                                  color:ColorTween(begin: primary, end: Colors.white).animate(animController).value
                              ),
                              onPressed: () {
                                if (animController.status == AnimationStatus.completed)
                                  animController.reverse();
                                if (animController.status == AnimationStatus.dismissed)
                                  animController.forward();
                              }),
                          title: Text(
                            /*"Small Habits"*/'',
                            style: TextStyle(color: Colors.black),
                          ),
                          centerTitle: true,
                          actions: <Widget>[
                            child!
                          ],
                        ),
                      ));
                },
                child: Tooltip(
                  message: "web: small-habits.com",
                  child: TextButton(
                      onPressed: ()async{
                        if (!await launch(smallHabitsWebUrl)) throw 'Could not launch $smallHabitsWebUrl';
                      }, child: Icon(FontAwesomeIcons.chrome)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      // color: Theme.of(context).brightness == Brightness.light
      //     ? Theme.of(context).colorScheme.secondary.withOpacity(0.9)
      //     : Theme.of(context).colorScheme.secondary.withOpacity(0.25),
      // child:/* Image(
      //   image: AssetImage('media/images/random_round_square.png'),
      //
      //   fit: BoxFit.fill,
      // ),*/
      // Image.network("https://firebasestorage.googleapis.com/v0/b/small-habits-0812.appspot.com/o/astronaut%20(1).jpg?alt=media&token=92ff8444-d939-48f8-975c-cc2a67b25a9a")

      foregroundDecoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      decoration: BoxDecoration(
          gradient: RadialGradient(
        radius: 1,
        center: Alignment(0.0, 0.0),
        stops: [
          0.5,
          1.1,
        ],
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
            ],
          )),
    );
  }
}
