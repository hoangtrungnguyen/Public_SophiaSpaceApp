import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/sophia_hub_app.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/view/animation/route_change_anim.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/pick_color_page.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/register/register_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterStepInputPwd extends StatefulWidget {
  RegisterStepInputPwd({Key? key}) : super(key: key);

  @override
  State<RegisterStepInputPwd> createState() => _RegisterStepInputPwdState();
}

class _RegisterStepInputPwdState extends State<RegisterStepInputPwd> {
  String pwd1 = '';

  String pwd2 = '';

  String email = '';

  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AccountViewModel auth = Provider.of<AccountViewModel>(context, listen: false);
    TextStyle textStyle = Theme.of(context).textTheme.headline6!.copyWith(
      color: Colors.white
    );
    Color primary = Theme.of(context).colorScheme.primary;
    return SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 72,
              left: 16,
              right: 16,
              bottom: 0,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Điền thông tin của bạn",
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(fontSize: 40,
                      color: primary),
                    ),
                    Spacer(flex: 5,),
                    TextFormField(
                      initialValue: auth.account.loginEmail ?? '',
                      style: textStyle,
                      decoration: InputDecoration(hintText: "Nhập Email"),
                      validator: (email) {
                        String? message;
                        if (email == null || email.isEmpty) {
                          message = "Mật khẩu không được để trống";
                        }
                        return message;
                      },
                      onChanged: (e) => this.email = e,
                    ),
                    Spacer(),
                    TextFormField(
                      initialValue: auth.account.loginPwd ?? '',
                      style: textStyle,
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
                      style:textStyle,
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
                      validator: checkFormatPwd,
                      onChanged: (e) => this.pwd2 = e,
                    ),
                    Spacer(
                      flex: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (!(_formKey.currentState?.validate() ?? false))
                            return;
                          auth.account
                              ..loginPwd = pwd2
                              ..loginEmail = email;

                          bool isOk = await auth.register(
                              auth.account.loginEmail!, auth.account.loginPwd!, auth.account.registerName ?? "NaN");

                          if (isOk) {

                            showSuccessMessage(context, "Đăng nhập thành công");

                            await Future.delayed(Duration(milliseconds: 1000));
                            Navigator.of(context, rootNavigator: true)
                                .pushAndRemoveUntil( RouteAnimation.buildDefaultRouteTransition(PickColorPage(), null) , (_)=> false);
                          } else {
                            showErrMessage(context, context.read<AccountViewModel>().error!);
                          }
                        },
                        style: ElevatedButtonTheme.of(context).style?.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                                Colors.white)),
                        child: Container(
                          height: 50,
                          width: 150,
                          alignment: Alignment.center,
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
                                        .headline6
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary));
                              }
                            },
                          ),
                        )),
                    TextButton(
                        onPressed: ()async{
                          if (!await launch(SophiaSpaceLink.privacyAndPolicy)){
                            showErrMessage(context, Exception("Không mở được đường dẫn"));
                          };
                        },
                      child: Text("Bằng cách đăng ký, bạn đã đồng ý với\nđiều khoản dịch vụ và chính sách bảo mật của chúng tôi",
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(fontSize: 8),),
                    ),
                    SizedBox(height: 4,)
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
