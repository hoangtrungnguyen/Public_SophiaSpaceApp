import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/base_container.dart';

class RegisterView extends StatefulWidget {
  final Function moveToLoginView;

  const RegisterView({Key key, this.moveToLoginView}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String email;
  String displayName;
  String pwd1;
  String pwd2;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

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
            Spacer(),
            TextFormField(
              decoration: InputDecoration(label: Text("Tên của bạn")),
              validator: (name) => name.isEmpty ? "Tên không được để trống" :  null,
              onChanged: (e) => this.displayName = e,
            ),
            TextFormField(
              decoration: InputDecoration(label: Text("Email")),
              validator: checkFormatEmail,
              onChanged: (e) => this.email = e,
            ),
            TextFormField(
              obscureText: _isObscure,
              decoration: InputDecoration(
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
                  label: Text("Mật khẩu")),
              onChanged: (pwd1) => this.pwd1 = pwd1,
              validator: (pwd) => pwd.isEmpty ? "Không được để trống" : this.pwd1 == this.pwd2 ? null : "Hai mật khẩu không khớp",
            ),
            TextFormField(
              obscureText: _isObscure,
              decoration: InputDecoration(
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
                  label: Text("Xác nhận mật khẩu")),
              onChanged: (pwd2) => this.pwd2 = pwd2,
              validator: (pwd) => pwd.isEmpty ? "Không được để trống" : this.pwd1 == this.pwd2 ? null : "Hai mật khẩu không khớp",
            ),
            ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState.validate()) return;
                  print("Loading");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang xử lý ...')),
                  );
                  Result<UserCredential> result = await userProvider
                      .register(email, pwd1, displayName: displayName);
                  print(result);
                  if (result.data != null) {
                    Navigator.of(context).pushReplacementNamed(BaseContainer.nameRoute);
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
                child: Text("Đăng ký")),
            Spacer(),
            Container(
              alignment: Alignment.bottomLeft,
              child: TextButton.icon(
                  onPressed: () {
                    widget.moveToLoginView.call();
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('')),
            )
          ],
        ),
      ),
    );
  }
}
