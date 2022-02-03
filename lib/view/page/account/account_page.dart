import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/share_pref.dart';
import 'package:sophia_hub/provider/auth.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view/widget/sophia_hub_close_button.dart';
import 'dart:math' as math;

class AccountPage extends StatefulWidget {
  static const String nameRoute = "/AccountPage";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return AccountPage();
    });
  }

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                        style: ElevatedButtonTheme.of(context).style?.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                                Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: scheme.primary,
                        )),
                  ),
                  Spacer(),
                  (auth.firebaseAuth.currentUser?.photoURL ?? "").isEmpty
                      ? Card(
                          child: SizedBox(
                              height: 150,
                              width: 150,
                              child: TextButton(
                                onPressed: () {  },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt_rounded),
                                    Text("Ảnh đại diện",textAlign: TextAlign.center,)
                                  ],
                                ),
                              )))
                      : CachedNetworkImage(
                          imageUrl:
                              auth.firebaseAuth.currentUser?.photoURL ?? '',
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: ShapeDecoration(
                                shape: continuousRectangleBorder,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                color: Colors.white,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              height: 150,
                              width: 150,
                            );
                          },
                          fadeOutDuration: Duration(milliseconds: 500),
                          useOldImageOnUrlChange: true,
                          errorWidget: (_, err, stackTrace) {
                            return Card(
                                child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Icon(Icons.error)));
                          },
                          placeholder: (context, url) {
                            return Center(child: AnimatedLoadingIcon());
                          },
                        ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  decoration: commonDecorationShadow,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue:
                            auth.firebaseAuth.currentUser?.displayName,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        readOnly: true,
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )),
                        initialValue: auth.firebaseAuth.currentUser?.email,
                      ),
                    ],
                  )),
              ColorThemePicker(),
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Đăng xuất"),
                  onTap: () async {
                    Result result =
                        await Provider.of<Auth>(context, listen: false)
                            .logOut();
                    print(result.error);
                    print(result.data);
                    if (result.isHasData) {
                      Navigator.of(context)
                          .pushReplacementNamed(AuthPage.nameRoute);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class ColorThemePicker extends StatefulWidget {
  const ColorThemePicker({Key? key}) : super(key: key);

  @override
  _ColorThemePickerState createState() => _ColorThemePickerState();
}

class _ColorThemePickerState extends State<ColorThemePicker> {
  late PageController _controller;

  late MaterialColor pickedColor;

  double viewPortFraction = 0.4;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: viewPortFraction)
      ..addListener(_scrollListener);
    pickedColor = Provider.of<SharedPref>(context, listen: false).materialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 250,
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: ShapeDecoration(
        shape: continuousRectangleBorder,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [
            0.1,
            1.0,
          ],
          colors: [
            pickedColor.shade500,
            pickedColor.shade300,
          ],
        ),
        shadows: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: Colors.primaries.length,
        itemBuilder: _colorBuilder,
      ),
    );
  }

  _scrollListener() {
    // print(_controller.page);
    // print(_controller);
    try {
      // print(_controller.);
      setState(() {
        curPage = _controller.page ?? 0;
      });
    } catch (e) {}
  }

  double curPage = 0;

  Widget _colorBuilder(BuildContext context, int index) {
    MaterialColor color = Colors.primaries[index];
    bool isPicked = color == pickedColor;
    double scale = math.max(
        viewPortFraction, (1 - (curPage - index).abs()) + viewPortFraction);

    Widget container = GestureDetector(
        onTap: () {
          setState(() {
            pickedColor = color;
            Provider.of<SharedPref>(context, listen: false).setColor(color);
          });
        },
        child: AnimatedContainer(
          margin: EdgeInsets.only(
              right: 15,
              left: 15,
              top: 100 - 30 * scale,
              bottom: 45 + 30 * scale),
          decoration: ShapeDecoration(
            shape:
                CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [
                0.5,
                1.0,
              ],
              colors: [
                color.shade500,
                color.shade300,
              ],
            ),
            shadows: [
              BoxShadow(
                color: color.shade50.withOpacity(0.2),
                spreadRadius: 1,
                offset: Offset(0.0, 4.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
          ),
          duration: Duration(milliseconds: 300),
        ));

    return container;
  }
}
