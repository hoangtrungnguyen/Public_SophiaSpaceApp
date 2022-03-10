import 'dart:math' as math;

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/helper/text_field_helper.dart';
import 'package:sophia_hub/view/page/account/user_avatar.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/share_pref.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String name = '';

  @override
  Widget build(BuildContext context) {
    AccountViewModel auth = Provider.of<AccountViewModel>(context);
    Size size = MediaQuery.of(context).size;
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
        floatingActionButton: name.isNotEmpty ? FloatingActionButton(
            onPressed: () async {
              if (name.isNotEmpty) {
                await auth.updateName(name);
                Flushbar(
                  backgroundColor: Colors.green,
                  message: "Lưu thành công",
                  flushbarPosition: FlushbarPosition.TOP,
                  borderRadius: BorderRadius.circular(16),
                  margin: EdgeInsets.all(8),
                  duration: Duration(seconds: 2),
                )..show(context);
              }
            },
            child: Selector<AccountViewModel, ConnectionState>(
                selector: (_,auth) => auth.appConnectionState,
                builder: (context, data, child) {
                  if (data == ConnectionState.done) {
                    return Icon(Icons.done);
                  } else {
                    return AnimatedLoadingIcon(
                      color: Colors.white,
                    );
                  }
                })) : null,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: size.height,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: ElevatedButton(
                            style: ElevatedButtonTheme.of(context)
                                .style
                                ?.copyWith(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color?>(
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
                      UserAvatar(),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Material(
                      elevation: 4,
                      shape: continuousRectangleBorder,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Column(
                          children: [
                            TextFormField(
                              maxLength: 20,
                              onChanged: (value) => name = value,
                              buildCounter: TextFieldHelper.buildCounter,
                              initialValue:
                                  FirebaseAuth.instance.currentUser?.displayName ?? "",
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(color: Colors.grey),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                  color: Colors.red
                                )),
                                  suffixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              )),
                              initialValue:
                              FirebaseAuth.instance.currentUser?.email ?? "",
                            ),
                            (){
                              bool emailVerified = auth.getCurrentUser()?.emailVerified ?? false;
                              return emailVerified ? SizedBox() : Row(
                                children: [
                                  Spacer(),
                                  InputChip(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.zero,
                                      onPressed: ()async{
                                        try {
                                          if (!await launch(
                                              "https://play.google.com/store/apps/details?id=com.google.android.gm")) throw 'Could not launch Gmail';
                                        } catch (e){
                                          showErrMessage(context, Exception("Lỗi đã xảy ra, xin thử lại sau"));
                                        }
                                      },
                                      label: Text("Xác thực email",style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.red),)),
                                ],
                              );
                            }()
                          ],
                        ),
                      )),
                  ColorThemePicker(),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Đăng xuất"),
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 500));
                        bool isOk =
                            (await Provider.of<AccountViewModel>(context, listen: false).logOut());
                        if (isOk) {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(AuthPage.nameRoute
                          ,(_) => false);
                        } else {
                          showErrMessage(context, Provider.of<AccountViewModel>(context, listen: false).error!);
                        }
                      },
                    ),
                  ),
                  // Spacer(),
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
    // bool isPicked = color == pickedColor;
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
                color: Colors.grey.shade50.withOpacity(0.2),
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
