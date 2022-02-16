import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/auth_validator.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/account_state_manager.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/register/step_1.dart';
import 'package:sophia_hub/view/page/auth/register/step_three.dart';
import 'package:sophia_hub/view/page/auth/register/step_two.dart';

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
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    AccountStateManager userProvider = Provider.of<AccountStateManager>(context, listen: false);

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
        child: ChangeNotifierProvider<TabController>(
          create: (_) => tabController,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned.fill(
                  child: TabBarView(
                    controller: tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [StepOne(), StepTwo(), StepThree()],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 16,
                  child: AnimatedOpacity(
                    opacity: context.watch<TabController>().index == 0 ? 1 : 0,
                    duration: Duration(milliseconds: 300),
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
                            onPressed: context.watch<TabController>().index == 0
                                ? () => Navigator.pop(context)
                                : null,
                            child: Icon(Icons.close_rounded),
                          )),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

  }
}
