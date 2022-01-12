import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

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
          child: Container(
              child: Column(
            children: <Widget>[
              FlutterLogo(
                size: 200,
                style: FlutterLogoStyle.stacked,
              ),
              ListTile(leading: Icon(Icons.person), title: Text("Cá nhân")),
              Spacer(flex: 9,),
              StreamBuilder<User>(
                stream: FirebaseAuth.instance.authStateChanges(), builder: (_,snapshot){
                if(snapshot.hasData){
                  return  ListTile( title: Text("Đăng xuất"));
                } else {
                  return  ListTile( title: Text("Đăng nhập"));
                }
              }),
              Spacer(flex: 1,),
              FutureBuilder<String>(
                future:
                    PackageInfo.fromPlatform().then((value) => value.version),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      "Phiên bản",
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.4)),
                    );
                  return Text("0.0.1");
                },
              ),
            ],
          )),
        ),
      ),
    );
  }
}
