import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/base_container.dart';

class LoginView extends StatefulWidget {
  final Function moveToRegisterView;

  const LoginView({Key key, this.moveToRegisterView}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String email;
  String pwd;
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(label: Text("Email")),
              validator: checkFormatEmail,
              onChanged: (e) => this.email = e,
            ),
            TextFormField(
              obscureText: _isObscure,
              decoration: InputDecoration(label: Text("Mật khẩu"),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              onChanged: (pwd) => this.pwd = pwd,
            ),
            ElevatedButton(
                onPressed: () async {
                  print("Loading");

                  if (!_formKey.currentState.validate()) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  Result<UserCredential> result =
                      await userProvider.login(email, pwd);
                  print(result);
                  if (result.data != null) {
                    Navigator.of(context)
                        .pushReplacementNamed(BaseContainer.nameRoute);
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                              child: Text("${result.error}"),
                          );
                        });
                  }
                },
                child: Text("Đăng nhập")),
            TextButton(
                onPressed: () {
                  widget.moveToRegisterView.call();
                },
                child: Text("Đăng ký"))
          ],
        ),
      ),
    );
  }
}
