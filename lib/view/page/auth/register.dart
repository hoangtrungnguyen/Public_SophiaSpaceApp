import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/base_container.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = "/register";

  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String email = '';
  String displayName = '';
  String pwd1 = '';
  String pwd2 = '';
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Auth userProvider = Provider.of<Auth>(context, listen: false);
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
              initialValue: '',
              style: TextStyle(
                  color: Colors.white
              ),
              decoration: InputDecoration(label: Text("Tên của bạn")),
              validator: (name) {
                String? message;
                if (name == null) {
                  message = "Tên không được để trống";
                }
                return message;
              },
              onChanged: (e) => this.displayName = e,
            ),
            SizedBox(height: 20,),
            TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
              decoration: InputDecoration(label: Text("Email")),
              validator: checkFormatEmail,
              onChanged: (e) => this.email = e,
            ),
            SizedBox(height: 20,),
            TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
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
              validator: (pwd) {
                String? message;

                if (pwd == null || pwd.isEmpty) {
                  message = "Mật khẩu không được để trống";
                }

                return message;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              style: TextStyle(
                  color: Colors.white
              ),
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
              validator: (pwd) {
                String? message;
                if (pwd == null || pwd.isEmpty) {
                  message = "Mật khẩu không được để trống";
                } else if (pwd != this.pwd1) {
                  message = "Hai mật khẩu không trùng nhau";
                }

                return message;
              },
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  print("Loading");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang xử lý ...')),
                  );
                  Result<UserCredential> result = await userProvider
                      .register(email, pwd1, displayName: displayName);
                  print(result);
                  if (result.data != null) {
                    Navigator.of(context, rootNavigator: true)
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
                child: Text("Đăng ký")),
            Spacer(),
            Container(
              alignment: Alignment.bottomLeft,
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.white,),
                  label: Text('')),
            )
          ],
        ),
      ),
    );
  }
}
