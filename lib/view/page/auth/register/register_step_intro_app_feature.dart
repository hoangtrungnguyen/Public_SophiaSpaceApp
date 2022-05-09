import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/view/animation/route_change_anim.dart';
import 'package:sophia_hub/view/page/auth/pick_color_page.dart';
import 'package:sophia_hub/view/page/auth/register/helper.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/register/register_view_model.dart';

class RegisterStepIntroAppFeature extends StatefulWidget {
  const RegisterStepIntroAppFeature({Key? key}) : super(key: key);

  @override
  _RegisterStepIntroAppFeatureState createState() => _RegisterStepIntroAppFeatureState();
}

class _RegisterStepIntroAppFeatureState extends State<RegisterStepIntroAppFeature> with RegisterHelper{
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .headline6
    !.copyWith(color: Colors.white);
    Color primary = Theme.of(context).colorScheme.primary;
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            Positioned(
                top: 72,
                left: 16,
                right: 16,
                bottom: 8,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Selector<AccountViewModel, String>(
                        selector: (context,viewModel) =>viewModel.account.registerName ?? '',
                          builder: (_,value, child)=>buildText("Rất vui được đồng hành cùng '$value' trên chuyến phiêu lưu này.", 0, textStyle),
                      ),
                      buildText("Hành trình vạn dặm bắt đầu bằng những bước nhỏ nhất", 1, textStyle),
                      AnimatedOpacity(
                        duration: Duration(seconds: 1),
                        opacity: subStep == 2 ? 1: subStep < 3 ? 0: 0.5,
                        child: Column(
                          children: [
                            Text("Trang bị bạn được hỗ trợ:",style: textStyle,),
                            Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.check_box_rounded,size: 30,color: Colors.white,),
                                  title: Text("Nhật ký hành trình", style: textStyle,),
                                ),
                                ListTile(
                                  leading: Icon(Icons.check_box_rounded,size: 30,color: Colors.white,),
                                  title: Text("Trích dẫn động lực", style: textStyle,),
                                ),
                                ListTile(
                                  leading: Icon(Icons.check_box_rounded,size: 30,color: Colors.white,),
                                  title: Text("Blog kiến thức", style: textStyle,),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      AnimatedOpacity(
                        duration: Duration(seconds: 1),
                        opacity: subStep == 3 ? 1: subStep < 4 ? 0: 0.5,
                        child: Column(
                          children: [
                            // Container(
                            //   child: ElevatedButton.icon(
                            //       onPressed: ()async{
                            //         if(await context.read<AccountViewModel>().signInWithGoogle(
                            //             context.read<AccountViewModel>().account.registerName ?? "No Name")){
                            //           showSuccessMessage(context, "Đăng nhập thành công");
                            //
                            //           await Future.delayed(Duration(milliseconds: 1000));
                            //           Navigator.of(context, rootNavigator: true)
                            //               .pushAndRemoveUntil( RouteAnimation.buildDefaultRouteTransition(PickColorPage(), null) , (_)=> false);
                            //
                            //         } else {
                            //           showErrMessage(context, context.read<AccountViewModel>().error);
                            //         };
                            //       },
                            //       style: ElevatedButtonTheme.of(context).style?.copyWith(
                            //           backgroundColor: MaterialStateProperty.all<Color?>(
                            //               Colors.white)),
                            //       icon: Icon(FontAwesomeIcons.google,color: primary,),
                            //       label: Text("Bắt đầu với Google",style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            //           color: Theme.of(context)
                            //               .colorScheme
                            //               .primary
                            //       ),)),
                            // ),
                            SizedBox(height: 10,),
                            Center(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.email,color: primary),
                                  onPressed: (){
                                    context.read<RegisterViewModel>().moveToNextStep();
                                  },
                                  style: ElevatedButtonTheme.of(context).style?.copyWith(
                                      backgroundColor: MaterialStateProperty.all<Color?>(
                                          Colors.white)),
                                  label: Text("Đăng ký với email",style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                  ),)),
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        height: subStep >= 3 ? 0:100,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (subStep < 4) {
                                subStep += 1;
                              }
                            });
                          },
                          child: Text("Tiếp tục",
                              style: textStyle.copyWith(
                                  color: Colors.white.withOpacity(0.6)
                              )),
                        ),
                      )
                    ])
            ),

          ],
        ),
      ),
    );
  }
}
