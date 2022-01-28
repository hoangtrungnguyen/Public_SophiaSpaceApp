import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/forgot/forgot_pwd.dart';

class LoginView extends StatefulWidget {
  static const String routeName = "/";

  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String email = '';
  String pwd = '';

  // Testing purpose only
  // String email = "c@gmail.com";
  // String pwd = "12345678";

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    Color primary = Theme.of(context).colorScheme.primary;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.1,
            1.0,
          ],
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
        )),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 12, right: 0),
                    height: 50,
                    width: 50,
                    decoration: ShapeDecoration(
                        color: Colors.grey.shade200.withOpacity(0.5),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(32))),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(Icons.close_rounded),
                    )),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 3,
                  ),
                  Text(
                    "Đăng nhập tài khoản",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(color: primary.withOpacity(0.7)),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Tooltip(
                    message: "Login email form field",
                    child: TextFormField(
                      initialValue: email,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Email",
                      ),
                      validator: checkFormatEmail,
                      onChanged: (e) => this.email = e,
                    ),
                  ),
                  SizedBox(height: 20),
                  Tooltip(
                    message: "Login password form field",
                    child: TextFormField(
                      initialValue: pwd,
                      obscureText: _isObscure,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Mật khẩu",
                      ),
                      onChanged: (pwd) => this.pwd = pwd,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ForgotPwd.routeName);
                    },
                    child: Text("Quên mật khẩu ?",
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white.withOpacity(0.5))),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                  ElevatedButton(
                      style: ElevatedButtonTheme.of(context).style?.copyWith(
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.white)),
                      onPressed: () async {
                        bool isValidForm =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValidForm) return;

                        Result<UserCredential> result =
                            await auth.login(email, pwd);
                        print(result);
                        if (result.data != null) {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(BaseContainer.nameRoute);
                        } else {
                          Flushbar(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            message: "Lỗi đã xảy ra, xin vui lòng thử lại sau",
                            flushbarPosition: FlushbarPosition.TOP,
                            borderRadius: BorderRadius.circular(16),
                            margin: EdgeInsets.all(8),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(
                          "Đăng nhập",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      )),
                  Spacer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
