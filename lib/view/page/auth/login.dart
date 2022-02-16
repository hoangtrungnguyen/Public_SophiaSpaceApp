import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/account_state_manager.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/forgot/forgot_pwd.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view/widget/sophia_hub_close_button.dart';

class LoginView extends StatefulWidget {
  static const String routeName = "/LoginView";

  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String email = '';
  String pwd = '';


  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  void initState() {
    super.initState();
    if(kDebugMode){
      this.email = "c@gmail.com";
      this.pwd = "12345678";
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountStateManager auth = Provider.of<AccountStateManager>(context, listen: false);
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
                child: SophiaHubCloseButton()
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
                  StreamBuilder<ConnectionState>(
                    stream: auth.appConnectionState,
                    builder: (BuildContext context, AsyncSnapshot<ConnectionState> snapshot) {
                      bool isWaiting = snapshot.data == ConnectionState.waiting;
                      return Container(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButtonTheme.of(context).style?.copyWith(
                                backgroundColor:
                                MaterialStateProperty.all<Color?>(Colors.white)),
                            onPressed:isWaiting  ? null: () async {
                              bool isValidForm =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValidForm) return;

                              bool isOk = await auth.login(email, pwd);
                              if (isOk) {
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacementNamed(BaseContainer.nameRoute);
                              } else {
                                showErrMessage(context, auth.error!);
                              }
                            },
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: isWaiting ? AnimatedLoadingIcon(): Text(
                                "Đăng nhập",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                    color: Theme.of(context).colorScheme.primary),
                              ),
                            )),
                      );
                    },
                  ),
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
