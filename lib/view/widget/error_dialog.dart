import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final Exception exception;

  const ErrorDialog({Key? key, required this.exception}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Lỗi không xác định đã xảy ra. Vui lòng thử lại sau"),
    );
  }
}
