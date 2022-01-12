import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  static const String nameRoute = "/AuthPage";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return AuthPage();
    });
  }

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
