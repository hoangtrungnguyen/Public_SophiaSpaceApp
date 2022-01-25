import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/register.dart';


class LoginView extends StatefulWidget {
  static const String routeName = "/";

  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
//  String email;
//  String pwd;

  // Testing purpose only
  String email = "c@gmail.com";
  String pwd = "12345678";

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);

    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child:  TextButton.icon(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back_rounded,color: Colors.white,), label: Text('')),
            ),
            Form(
              key: _formKey,
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Text("Đăng nhập tài khoản",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.7)
                    ),),
                  Spacer(),
                  Tooltip(
                    message: "Login email form field",
                    child: TextFormField(
                      initialValue: email,
                      style: TextStyle(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(label: Text("Email")),
                      validator: checkFormatEmail,
                      onChanged: (e) => this.email = e,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Tooltip(
                    message: "Login password form field",
                    child: TextFormField(
                      initialValue: pwd,
                      obscureText: _isObscure,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        label: Text("Mật khẩu"),
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
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        print("Loading");
                        bool isValidForm = _formKey.currentState?.validate() ?? false;
                        if (!isValidForm) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing Data'),
                          ),
                        );
                        Result<UserCredential> result =
                            await auth.login(email, pwd);
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
                      child: Text("Đăng nhập")),

                  Spacer(flex: 2,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
