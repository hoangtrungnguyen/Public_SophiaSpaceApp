import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/login.dart';
import 'package:sophia_hub/view/page/auth/register.dart';

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
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      // wrong call in wrong place!
      Navigator.of(context,rootNavigator: true).pushNamedAndRemoveUntil(BaseContainer.nameRoute,
              (route) => route.settings.name == AuthPage.nameRoute);
     return;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(
        context, listen: false);
    return Scaffold(
      body: Navigator(

        initialRoute: LoginView.routeName,
        onGenerateRoute: (settings){
          //Read more in the link below
          // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
          WidgetBuilder builder;
          switch (settings.name) {
            case LoginView.routeName:
              builder = (_) => const LoginView();break;
            case RegisterView.routeName:
              builder = (_) => const RegisterView();break;
            default:
              assert(false, 'Need to implement ${settings.name}');
          }

          MaterialPageRoute route = MaterialPageRoute(
            builder: builder,
          );
          return route;
        },
      )
    );
  }



}
