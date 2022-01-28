import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/base_container.dart';

class StepThree extends StatefulWidget {
  StepThree({Key? key}) : super(key: key);

  @override
  State<StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  String pwd1 = '';

  String pwd2 = '';

  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return SafeArea(
        child: Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
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
                  onPressed: () =>
                      Provider.of<TabController>(context, listen: false)
                          .animateTo(1),
                  child: Icon(Icons.arrow_back_rounded),
                )),
          ),
          Positioned.fill(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Spacer(
                    flex: 5,
                  ),
                  Text(
                    "Mật khẩu của bạn",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                  TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
                    validator: checkFormatPwd,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() {
                            _isObscure = !_isObscure;
                          }),
                        ),
                        hintText: "Mật khẩu"),
                    onChanged: (e) => this.pwd1 = e,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  TextFormField(
                    obscureText: _isObscure,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() {
                            _isObscure = !_isObscure;
                          }),
                        ),
                        hintText: "Nhập lại mật khẩu"),
                    validator: (pwd) {
                      String? message;
                      if (pwd == null || pwd.isEmpty)
                        message = "Mật khẩu không được để trống";
                      else if (pwd != this.pwd1)
                        message = "Hai mật khẩu không trùng nhau";
                      return message;
                    },
                    onChanged: (e) => this.pwd2 = e,
                  ),
                  Spacer(
                    flex: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!(_formKey.currentState?.validate() ?? false))
                            return;
                          auth.user.password = pwd2;

                          Result<UserCredential> result = await auth.register(
                              auth.user.email!, auth.user.password!);
                          if (result.data != null) {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacementNamed(BaseContainer.nameRoute);
                          } else {
                            Flushbar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              message:
                                  "Lỗi đã xảy ra, xin vui lòng thử lại sau",
                              flushbarPosition: FlushbarPosition.TOP,
                              borderRadius: BorderRadius.circular(16),
                              margin: EdgeInsets.all(8),
                              duration: Duration(seconds: 3),
                            )..show(context);
                          }
                        },
                        style: ElevatedButtonTheme.of(context).style?.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                                Colors.white)),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Text("Tiếp tục",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
