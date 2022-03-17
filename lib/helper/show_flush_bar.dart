import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sophia_hub/helper/debug_print.dart';
import 'package:sophia_hub/model/exception/pin_exception.dart';

extension ShowMessage on Flushbar {}

void showErrMessage(BuildContext context, Exception exception, {String? message}) async {
  String errMessage = message ?? 'Lỗi đã xảy ra, xin vui lòng thử lại sau';
  if (exception is PinException) {
    errMessage = "Mã pin không đúng, xin vui lòng thử lại";
  } else if (exception is FirebaseAuthException) {
    if (kDebugMode) {
      print(exception.code);
    }

    switch (exception.code) {
      case "invalid-email":
        errMessage = "Email không hợp lệ";
        break;
      case "user-disabled":
        errMessage = "Tài khoản bị khóa";
        break;
      case "user-not-found":
        errMessage = "Không tìm thấy người dùng";
        break;
      case "wrong-password":
        errMessage = "Sai mật khẩu";
        break;
      case "network-request-failed":
        errMessage = "Không thể kết nối tới mạng";
        break;
      case "unknown":
        errMessage = "Lỗi không xác đinh đã xảy ra, xin thử lại sau";
        break;
      case "email-already-in-use":
        errMessage = "Email đã được sử dụng bởi một tài khoản khác";
        break;
    }
  } else if (exception is FirebaseException) {
    switch (exception.code) {
      case "unauthorized":
        errMessage = "Không thể truy cập";
        break;
    }
  } else {
    printDebug(exception);
  }

  Flushbar(
    backgroundColor: Theme.of(context).colorScheme.error,
    message: errMessage,
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(16),
    margin: EdgeInsets.all(8),
    duration: Duration(seconds: 3),
  ).show(context);
}

void showLoadingMessage(BuildContext context) {
  Flushbar(
    message: "Loading...",
    flushbarPosition: FlushbarPosition.BOTTOM,
    borderRadius: BorderRadius.circular(16),
    margin: EdgeInsets.all(8),
    duration: Duration(seconds: 4),
  ).show(context);
}

void showSuccessMessage(BuildContext context, String? message) async {
  Flushbar(
    message: message ?? "Thành công",
    backgroundColor: Colors.green,
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(16),
    margin: EdgeInsets.all(8),
    duration: Duration(seconds: 3),
  ).show(context);
}

void showMessage(BuildContext context, String? message) async {
  Flushbar(
    message: message ?? "Thành công",
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(16),
    margin: EdgeInsets.all(8),
    duration: Duration(seconds: 2),
  ).show(context);
}
