import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/text_field_helper.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/register/register_view_model.dart';

import 'helper.dart';

class RegisterStepInputName extends StatefulWidget {
  const RegisterStepInputName({Key? key}) : super(key: key);

  @override
  _RegisterStepInputNameState createState() => _RegisterStepInputNameState();
}

class _RegisterStepInputNameState extends State<RegisterStepInputName> with RegisterHelper{
  final _formKey = GlobalKey<FormState>();
  String _displayName = '';


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AccountViewModel auth = Provider.of<AccountViewModel>(context, listen: false);
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .headline6
    !.copyWith(color: Colors.white);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText("Ứng dụng SophiaSpace giúp bạn khám phá tiềm năng của bản thân, giúp bạn có một cuộc sống thú vị và cân bằng hơn ...",0, textStyle,),
                  buildText("... bằng các công cụ và kỹ thuật dựa trên những nghiên cứu về tâm lý học",1, textStyle,),
                  buildText("Ghi danh vào phi hành đoàn:", 2, textStyle),
                  AnimatedOpacity(
                    duration: Duration(seconds: 1),
                    opacity: subStep == 3? 1.0: 0.0,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(

                        initialValue: auth.account.registerName ?? '',
                        maxLength: 20,
                        buildCounter: TextFieldHelper.buildCounter,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                        validator: (name) => name == null || name.isEmpty
                            ? "Tên không được để trống"
                            : null,
                        onChanged: (e) {
                          _displayName = e;
                          auth.account.registerName = _displayName;
                        },
                        decoration: InputDecoration(
                          hintText: "Tên của bạn",
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {

                          setState(() {
                            if (subStep < 4) {
                              subStep += 1;
                            }
                          });

                          if(subStep < 4)
                            return;

                          if (!(_formKey.currentState?.validate() ?? false))
                            return;

                          Provider.of<RegisterViewModel>(context, listen: false).moveToNextStep();
                        },
                        child: Text("Tiếp tục",
                            style: textStyle.copyWith(
                                color: Colors.white.withOpacity(0.6)
                            )),
                  ),)
                  ])
            ),

              ],
            ),
        ),
    );
  }


}
