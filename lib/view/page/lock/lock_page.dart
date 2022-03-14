import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:provider/src/provider.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/helper/text_field_helper.dart';
import 'package:sophia_hub/view_model/share_pref.dart';

class LockPage extends StatefulWidget {
  static const nameRoute = "/LockPage";

  const LockPage({Key? key}) : super(key: key);

  @override
  _LockPageState createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  final LocalAuthentication auth = LocalAuthentication();
  late bool isBiometricSupported = false;

  String _pinCode = '';

  @override
  void initState() {
    super.initState();
    _authBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isBiometricSupported ? SizedBox():TextField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              buildCounter: TextFieldHelper.buildCounter,
              onChanged: (pincode) {
                setState(() {
                  _pinCode = pincode;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (this.isBiometricSupported)
                  _authBiometric();
                else
                  _authByPinCode();
              },
              child: Text("Xác thực"),
            ),
          ],
        ),
      ),
    );
  }

  _authBiometric() async {
    final types = await auth.getAvailableBiometrics();
    this.isBiometricSupported = types.isNotEmpty;
    setState(() {

    });
    // this.isBiometricSupported = false;

    if (this.isBiometricSupported) {
      try {
        bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Xác thực để vào', biometricOnly: true);

        if (didAuthenticate) {
          Navigator.popUntil(
              context, (route) => route.settings.name != LockPage.nameRoute);
        } else {}
      } on PlatformException catch (e) {
        showErrMessage(context, e);
        if (e.code == auth_error.notAvailable) {
          // Handle this exception here.
        }
      }
    } else {
      //Sử dụng pincode
      setState(() {});
    }
  }

  _authByPinCode() async {
    final isOk = await context.read<SharedPref>().authPinCode(_pinCode);
    if (isOk) {
      Navigator.popUntil(
          context, (route) => route.settings.name != LockPage.nameRoute);
    } else {
      showErrMessage(context, context.read<SharedPref>().error!);
    }
  }
}
