import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/account/account_page.dart';

class PickColorPage extends StatefulWidget {
  const PickColorPage({Key? key}) : super(key: key);

  @override
  _PickColorPageState createState() => _PickColorPageState();
}

class _PickColorPageState extends State<PickColorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
      child: Column(
        children: [
          Text("Chọn màu của bạn"),
          ColorThemePicker(),
          Center(
            child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil( BaseContainer.nameRoute , (_)=> false);

                },
                style: ElevatedButtonTheme.of(context).style?.copyWith(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                        Colors.white)),
                child: Text("Đăng ký với email",style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                ),)),
          )
        ],
      )),
    );
  }
}
