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

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  late AnimationController _starterAnim;
  late AnimationController _lateAnim;

  @override
  void initState() {
    _starterAnim =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..forward()
          ..addListener(() {
            if (_starterAnim.isCompleted) {
              _lateAnim.forward();
            }
          });
    _lateAnim = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    _starterAnim.dispose();
    _lateAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1.0],
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary
              ],
            )),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                    child: FadeTransition(
                  opacity:
                      _starterAnim.drive(Tween<double>(begin: 1.0, end: 0.7)),
                  child: Image(
                    image: AssetImage('media/images/astronaut.jpg'),
                    fit: BoxFit.fill,
                  ),
                )),
                Positioned(
                  left: 20,
                  right: 20,
                  top: 120,
                  child: FadeTransition(
                    opacity: _starterAnim,
                    child: Text(
                      "Nhật ký của bạn",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(0, 0.85),
                    child: FadeTransition(
                      opacity: _lateAnim,
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pushNamed(
                                context, RegisterView.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              "Bắt đầu",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.white),
                            ),
                          )),
                    )),
                Align(
                  alignment: Alignment(0, 0.97),
                  child: FadeTransition(
                    opacity: _lateAnim,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginView.routeName);
                        },
                        child: Text(
                          "Đã có tài khoản",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
