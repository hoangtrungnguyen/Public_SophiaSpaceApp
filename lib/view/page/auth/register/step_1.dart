import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/provider/auth.dart';

class StepOne extends StatefulWidget {
  const StepOne({Key? key}) : super(key: key);

  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  final _formKey = GlobalKey<FormState>();
  String _displayName = '';

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Spacer(
                  flex: 5,
                ),
                Text(
                  "Hãy điền tên mà bạn muốn hiển thị",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.white),
                ),
                Spacer(
                  flex: 5,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    initialValue: auth.user.displayName ?? '',
                    maxLength: 20,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
                    validator: (name) => name == null || name.isEmpty
                        ? "Tên không được để trống"
                        : null,
                    onChanged: (e) {
                      _displayName = e;
                      auth.user.displayName = _displayName;
                    },
                    decoration: InputDecoration(
                      hintText: "Tên của bạn",
                    ),
                  ),
                ),
                Spacer(
                  flex: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                      onPressed: () {
                        if (!(_formKey.currentState?.validate() ?? false))
                          return;
                        Provider.of<TabController>(context, listen: false)
                            .animateTo(1);
                      },
                      style: ElevatedButtonTheme.of(context).style?.copyWith(
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.white)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text("Tiếp tục",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
