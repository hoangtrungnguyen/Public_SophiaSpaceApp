import 'package:flutter/material.dart';
import 'package:sophia_hub/view/page/auth/login.dart';
import 'package:sophia_hub/view/page/auth/register.dart';

class Welcome extends StatefulWidget {
  static const String nameRoute = "/";

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
  late AnimationController _animation1;
  late AnimationController _animation2;
  late AnimationController _animation3;
  late AnimationController _animation4;

  @override
  void initState() {
    _animation1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..forward()
          ..addListener(() {
            if (_animation1.isCompleted) {
              _animation2.forward();
            }
          });
    _animation2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            if (_animation2.isCompleted) {
              _animation3.forward();
            }
          });
    ;

    _animation3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            if (_animation3.isCompleted) {
              _animation4.forward();
            }
          });
    ;

    _animation4 = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    _animation1.dispose();
    _animation4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 1.0],
            colors: [
              // Theme.of(context).colorScheme.secondary,
              Colors.black,
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
                opacity: _animation1.drive(Tween<double>(begin: 1.0, end: 0.7)),
                child: Image(
                  image: AssetImage('media/images/astronaut2.jpg'),
                  fit: BoxFit.fill,
                ),
              )),
              Positioned(
                top: 8,
                right: 8,
                child: SafeArea(
                  child: FadeTransition(
                    opacity: _animation2,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginView.routeName);
                        },
                        child: Text(
                          "Tiếp tục hành trình",
                          style:
                          TextStyle(color: Colors.white.withOpacity(0.8)),
                        )),
                  ),
                ),
              ),


              Positioned(
                left: 20,
                right: 20,
                top: 120,
                child: FadeTransition(
                  opacity: _animation2,
                  child: Text(
                    "Nhật ký\nkhám phá bản thân",
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                  bottom: 24,
                  left: 32,
                  right: 32,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _animation3,
                        child: Text(
                          "Nâng cấp cuộc sống bằng những\nkỹ thuật tâm lý học",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FadeTransition(
                        opacity: _animation4,
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pushNamed(
                                  context, RegisterView.routeName);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: Text(
                                "Bắt đầu hành trình",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: Colors.white),
                              ),
                            )),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
