import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  static const String nameRoute = "/Welcome";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return Welcome();
    });
  }

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Image.asset(
        'images/astrounant.jpg',
        package: 'media',
      ),
    ));
  }
}
