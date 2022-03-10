import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/view/page/auth/register/register_step_input_name.dart';
import 'package:sophia_hub/view/page/auth/register/register_step_intro_app_feature.dart';
import 'package:sophia_hub/view/page/auth/register/step_two.dart';
import 'package:sophia_hub/view_model/register/register_view_model.dart';

import 'register/register_step_intro.dart';
import 'register/register_step_singup_with_email_pwd.dart';


class RegisterView extends StatefulWidget {
  static const String routeName = "/register";

  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  String email = '';
  String displayName = '';
  String pwd1 = '';
  String pwd2 = '';
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.1,
            1.0,
          ],
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
        )),
        child: ChangeNotifierProvider<RegisterViewModel>(
          create: (_) =>
              RegisterViewModel()..tabController = this.tabController,
          builder: (context, child) {
            return SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: TabBarView(
                      controller:
                          context.read<RegisterViewModel>().tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [RegisterStepIntro(), RegisterStepInputName(), RegisterStepIntroAppFeature(),
                        RegisterStepInputPwd()
                      ],
                    ),
                  ),
                  //close button
                  Positioned(
                      top: 8,
                      right: 16,
                      child: Selector<RegisterViewModel, bool>(
                        selector: (_, viewModel) =>
                            viewModel.curIndex == 0,
                        builder: (context, value, child) {
                          return AnimatedOpacity(
                            opacity: value ? 1 : 0,
                            duration: Duration(milliseconds: 300),
                            child: child!,
                          );
                        },
                        child: Material (
                          shape: continuousRectangleBorder,
                          color: Colors.grey.shade200.withOpacity(0.5),
                          child: Container(
                            height: 50,
                            width: 50,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Icon(Icons.close_rounded),
                            ),
                          ),
                        ),
                      )),
                  //Leading button app bar
                  Positioned(
                    top: 8,
                    left: 16,
                    child:  Selector<RegisterViewModel, bool>(
                      selector: (_, viewModel) =>
                      viewModel.curIndex != 0,
                      builder: (context, value, child) {
                        return AnimatedOpacity(
                          opacity: value ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          child: child!,
                        );
                      },
                      child: Material (
                        shape: continuousRectangleBorder,
                        color: Colors.grey.shade200.withOpacity(0.5),
                        child: Container(
                          height: 50,
                          width: 50,
                          child: TextButton(
                            onPressed: () => context.read<RegisterViewModel>().moveToPreviousStep(),
                            child: Icon(Icons.arrow_back_outlined),
                          ),
                        ),
                      ),
                    ),
                    /*child: AnimatedOpacity(
                      opacity: context
                                  .watch<RegisterViewModel>()
                                  .tabController
                                  .index !=
                              0
                          ? 1
                          : 0,
                      duration: Duration(milliseconds: 300),
                      child: Material(
                        shape: continuousRectangleBorder,
                        color: Colors.grey.shade200.withOpacity(0.5),
                        child: Container(
                            height: 50,
                            width: 50,
                            child: TextButton(
                              onPressed: context
                                          .watch<RegisterViewModel>()
                                          .tabController
                                          .index ==
                                      0
                                  ? () => Navigator.pop(context)
                                  : () => context
                                      .read()<RegisterViewModel>()
                                      .moveToPreviousStep(),
                              child: Icon(Icons.arrow_back_outlined),
                            )),
                      ),
                    ),*/
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
