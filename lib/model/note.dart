import 'package:flutter/foundation.dart';

class Subject{
  String name;
  String icon;
}

class Note with ChangeNotifier{
  int emotionPoint = 0;
  List<Subject> subjects = [];
  String title;
  String description;
  DateTime timeCreated;

  @override
  String toString() {
    return """{
      "emotionPoint": $emotionPoint;
      "title": $title;
      "description": $description;
    }""";
  }


}