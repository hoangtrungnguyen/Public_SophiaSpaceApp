import 'package:flutter/cupertino.dart';

class Task with ChangeNotifier {
  String? title;
  String? description;
  DateTime? timeCreated;
}
