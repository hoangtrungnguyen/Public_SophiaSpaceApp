import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sophia_hub/helper/debug_print.dart';

extension ShowMessage on Flushbar {}

void showErrMessage(BuildContext context, Exception exception) async {
  String errMessage = 'Lỗi đã xảy ra, xin vui lòng thử lại sau';
  if (exception is FirebaseAuthException) {
    /// - **invalid-email**:
    ///  - Thrown if the email address is not valid.
    /// - **user-disabled**:
    ///  - Thrown if the user corresponding to the given email has been disabled.
    /// - **user-not-found**:
    ///  - Thrown if there is no user corresponding to the given email.
    /// - **wrong-password**:
    ///  - Thrown if the password is invalid for the given email, or the account
    ///    corresponding to the email does not have a password set.
    switch ((exception).code) {
      case "auth/invalid-email":
        errMessage = "Email không hợp lệ";
        break;
      case "auth/user-disabled":
        errMessage = "Tài khoản bị khóa";
        break;
      case "auth/user-not-found":
        errMessage = "Không tìm thấy người dùng";
        break;
      case "auth/wrong-password":
        errMessage = "Sai mật khẩu";
        break;
    }
  } else {
    printDebug(exception);
  }

  Flushbar(
    backgroundColor:
    Theme.of(context).colorScheme.error,
    message: errMessage,
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(16),
    margin: EdgeInsets.all(8),
    duration: Duration(seconds: 3),
  ).show(context);
}

void showSuccessMessage(BuildContext context, String? message) async {
  Flushbar(
    title: message ?? "Thành công",
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(16),
    margin: EdgeInsets.all(8),
    duration: Duration(seconds: 3),
  ).show(context);
}

