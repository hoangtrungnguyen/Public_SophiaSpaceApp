import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';

class ForgotPwd extends StatefulWidget {
  static const String routeName = "/forgot";

  ForgotPwd({Key? key}) : super(key: key);

  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  final _formKey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    AccountViewModel auth = Provider.of<AccountViewModel>(context, listen: false);
    Color primary = Theme.of(context).colorScheme.primary;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: backgroundLinearGradient(context)),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
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
                      child: Icon(Icons.arrow_back_rounded),
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
                    "Điền email của bạn",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white),
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
                        Result result = await auth.resetPwd(email);
                        if (result.data != null)
                          Flushbar(
                            message: result.data['message'],
                            flushbarPosition: FlushbarPosition.TOP,
                            borderRadius: BorderRadius.circular(16),
                            margin: EdgeInsets.all(8),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        else
                          Flushbar(
                            message:
                                "Lỗi không xác định đã xảy, vui lòng thử lại sau.",
                            flushbarPosition: FlushbarPosition.TOP,
                            borderRadius: BorderRadius.circular(16),
                            margin: EdgeInsets.all(8),
                            duration: Duration(seconds: 3),
                          )..show(context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(
                          "Lấy lại mật khẩu",
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
