import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/src/provider.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/helper/text_field_helper.dart';
import 'package:sophia_hub/view_model/share_pref.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class CodePinWidget extends StatefulWidget {
  const CodePinWidget({Key? key}) : super(key: key);

  @override
  _CodePinWidgetState createState() => _CodePinWidgetState();
}

class _CodePinWidgetState extends State<CodePinWidget> {
  final LocalAuthentication auth = LocalAuthentication();
  late bool isBiometricSupported = false;

  @override
  void initState() {
    super.initState();

    auth.getAvailableBiometrics().then((List<BiometricType> types) {
      setState(() {
        this.isBiometricSupported = types.isNotEmpty;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        activeTrackColor: Theme.of(context).colorScheme.secondary,
      activeColor:Theme.of(context).colorScheme.primary,
      title: Text("Khóa ${isBiometricSupported ? "sinh trắc" : ""} bảo vệ"),
      subtitle: Text(
          "${context.watch<SharedPref>().isLockActivate ? 'Hoạt động' : 'Không hoạt động'}\n"),
      onChanged: (bool value) async {
        // _checkIsLockActive
        // If Yes:
        //    update SharePref
        // If No
        //    _checkIsHasBiometric
        //      If Yes
        //          call app biometric function
        //          update bool in SharePref
        //      If No
        //          set Pwd
        //          update bool in SharePref

        if (context.read<SharedPref>().isLockActivate) {
          context.read<SharedPref>().updateIsLockActive();
        } else {
          if (isBiometricSupported) {
            bool didAuthenticate = await auth.authenticate(
                localizedReason: 'Xác thực vân tay', biometricOnly: true);
            if (didAuthenticate) {
              context.read<SharedPref>().updateIsLockActive();
            } else {
              showErrMessage(context, Exception('Xác thực thất bại'));
            }
          } else {
            bool? isOk = await showDialog<bool>(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return PinCodeDialog();
                });

            if (isOk!) {
              context.read<SharedPref>().updateIsLockActive();
            }
          }
        }
      },
      value: context.watch<SharedPref>().isLockActivate,
    );
  }
}

class PinCodeDialog extends StatefulWidget {
  const PinCodeDialog({Key? key}) : super(key: key);

  @override
  _PinCodeDialogState createState() => _PinCodeDialogState();
}

class _PinCodeDialogState extends State<PinCodeDialog> {
  String _pincode = '';

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Đặt mã bảo vệ"),
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      children: [
        SizedBox(
          height: 16,
        ),
        TextField(
          maxLength: 4,
          keyboardType: TextInputType.number,
          buildCounter: TextFieldHelper.buildCounter,
          onChanged: (pincode) {
            setState(() {
              _pincode = pincode;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                child: Icon(Icons.done_outline),
                onPressed: _pincode.length == 4 ? () {
                  try {
                    context.read<SharedPref>().setPinCode(_pincode);
                    Navigator.of(context).pop(true);
                  } catch(e){
                    showErrMessage(context, Exception());
                  }

                } : null,),
            TextButton(
              child: Icon(Icons.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        )
      ],
    );
  }
}
