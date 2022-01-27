import 'package:flutter/material.dart';
import 'package:sophia_hub/view/page/auth/login.dart';
import 'package:sophia_hub/view/page/auth/register.dart';

class Welcome extends StatefulWidget {
  static const String nameRoute = "/Welcome";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return Welcome();
    });
  }

  const Welcome();

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image(
                image: AssetImage('media/images/astronaut.jpg'),
                fit: BoxFit.fill,
              )),
              Align(
                alignment: Alignment(0,0.85),
                  child: ElevatedButton(

                      onPressed: () async {
                        Navigator.pushNamed(context, RegisterView.routeName);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(
                          "Bắt đầu",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: Colors.white),
                        ),
                      ))),
              Align(
                 alignment: Alignment(0,0.97),
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginView.routeName);
                    },
                    child: Text(
                      "Đã có tài khoản",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ));
  }
}
