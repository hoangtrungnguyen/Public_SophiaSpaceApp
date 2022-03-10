import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view/page/auth/register/helper.dart';
import 'package:sophia_hub/view_model/register/register_view_model.dart';

class RegisterStepIntro extends StatefulWidget {
  const RegisterStepIntro({Key? key}) : super(key: key);

  @override
  _RegisterStepIntroState createState() => _RegisterStepIntroState();
}

class _RegisterStepIntroState extends State<RegisterStepIntro> with RegisterHelper {

  bool? isStruggle;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white);
    return SafeArea(
      child: DefaultTextStyle(
        style: textStyle,
        child: Container(
          child: Stack(
            children: [
              Positioned(
                  top: 72,
                  bottom: 8,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildText("Chào mừng bạn", 0, textStyle),
                      buildText("Tôi tin rằng chìa khóa để có một cuộc sống hạnh phúc và ý nghĩa là những thói quen tốt.", 1, textStyle),
                      buildText("Rất nhiều người gặp khó khăn trong việc xây dựng những thói quen tốt mới.", 2, textStyle),
                      buildText("Bạn có gặp khó khăn tương tự không?", 3, textStyle),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 1000),
                        opacity:subStep == 4 || subStep == 5 ? 1.0 : 0.0,
                        child: Column(
                          children: [
                            RadioListTile<bool?>(
                                activeColor: Colors.white,
                                title: Text(
                                  "Có",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(color: Colors.white),
                                ),
                                value: true,
                                groupValue: this.isStruggle,
                                onChanged: (value) {
                                  setState(() {
                                    this.isStruggle = value;
                                  });
                                }),
                            RadioListTile<bool?>(
                                activeColor: Colors.white,
                                title: Text(
                                  "Không",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(color: Colors.white),
                                ),
                                value: false,
                                groupValue: this.isStruggle,
                                onChanged: (value) {
                                  setState(() {
                                    this.isStruggle = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Center(
                          child: TextButton(
                              onPressed: _onNext,
                              child: Text("Ấn để tiếp tục",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color:
                                              Colors.white.withOpacity(0.6)))))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }


  void _onNext() {
    setState(() {
      if (subStep < 5) {
        subStep += 1;
      }
    });
    if (subStep == 5 && this.isStruggle != null) {
      context.read<RegisterViewModel>().moveToNextStep();
    }
  }
}
