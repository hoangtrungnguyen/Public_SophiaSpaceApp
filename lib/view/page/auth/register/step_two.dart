import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/register/register_view_model.dart';

class StepTwo extends StatefulWidget {
  const StepTwo({Key? key}) : super(key: key);

  @override
  State<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  String email1 = '';
  String email2 = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.email1 = Provider.of<AccountViewModel>(context,listen: false).account.loginEmail ?? '';
    this.email2 = Provider.of<AccountViewModel>(context,listen: false).account.loginEmail ?? '';
  }
  @override
  Widget build(BuildContext context) {
    AccountViewModel auth = Provider.of<AccountViewModel>(context);

    return SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Positioned.fill(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Spacer(
                    flex: 5,
                  ),
                  Text(
                    "Email của bạn",
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
                    initialValue: auth.account.loginEmail ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
                    validator: checkFormatEmail,
                    decoration: InputDecoration(hintText: "Email"),
                    onChanged: (e) {
                      this.email1 = e;
                      auth.account.loginEmail = this.email1;
                    },
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  TextFormField(
                    initialValue: auth.account.loginEmail ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
                    decoration: InputDecoration(hintText: "Nhập lại Email"),
                    validator: (email) {
                      String? message;
                      if (email == null || email.isEmpty) {
                        message = "Mật khẩu không được để trống";
                      } else if (email != this.email1) {
                        message = "Hai email không trùng nhau";
                      }

                      return message;
                    },
                    onChanged: (e) => this.email2 = e,
                  ),
                  Spacer(
                    flex: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                        onPressed: () {
                          if (!(_formKey.currentState?.validate() ?? false))
                            return;
                          auth.account.loginEmail = email1;
                          context.read<RegisterViewModel>()
                              .moveToNextStep();
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
