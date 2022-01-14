import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';

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
                  ListTile(leading: Icon(Icons.logout),
                    title: Text("Đăng xuất"),
                    onTap: () async {
                      Result result = await Provider.of<UserProvider>(
                          context, listen: false).logOut();
                      print(result.error);
                      print(result.data);
                      if (result.isHasData) {
                        Navigator.of(context).pushReplacementNamed(
                            AuthPage.nameRoute);
                      }
                    },),
                  Spacer(flex: 1,),
                  FutureBuilder<String>(
                    future:
                    PackageInfo.fromPlatform().then((value) => value.version),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData)
                        return Text(
                          "Phiên bản",
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
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
