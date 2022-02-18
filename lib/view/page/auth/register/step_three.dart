import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';

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
    AccountViewModel auth = Provider.of<AccountViewModel>(context, listen: false);
    return SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
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
                    initialValue: auth.account.loginPwd ?? '',
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
                    initialValue: auth.account.loginPwd ?? '',
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
                          auth.account.loginPwd = pwd2;

                          bool isOk = await auth.register(
                              auth.account.loginEmail!, auth.account.loginPwd!, auth.account.registerName ?? "NaN");

                          if (isOk) {
                            await Future.delayed(Duration(milliseconds: 500));
                            showSuccessMessage(context, "Đăng nhập thành công");
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
                        child: Container(
                          height: 50,
                          width: 180,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Selector<AccountViewModel, ConnectionState>(
                            selector: (_, account) => account.appConnectionState,
                            builder: (context, data, child) {
                              if (data == ConnectionState.waiting) {
                                return AnimatedLoadingIcon();
                              } else {
                                return Text("Tiếp tục",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary));
                              }
                            },
                          ),
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
