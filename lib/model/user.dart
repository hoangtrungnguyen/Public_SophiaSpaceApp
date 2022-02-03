import 'package:flutter/cupertino.dart';

class UserData extends ChangeNotifier {
  String? name;
  String? email;
  String? password;
  String? id;

  String? displayName;

  void clear() {
    name = '';
    email = '';
    password = '';
  }
}