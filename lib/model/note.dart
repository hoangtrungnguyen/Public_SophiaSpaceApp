import 'package:flutter/foundation.dart';

class Subject {
  String name;
  String icon;
}

///
/// [day] is the day since epoch
///

//TODO: Thêm tự động tạo JSON objects cho các class model này
class Note with ChangeNotifier {
  int emotionPoint = 0;
  List<Subject> subjects = [];
  String title;
  String description;

  // day may not be change
  final String day;
  DateTime timestamp = DateTime.now();

  Note(
      {@required this.title,
      @required this.description,
      @required this.day,
      this.subjects}) {}

  @override
  String toString() {
    return """{
      "emotionPoint": $emotionPoint;
      "title": $title;
      "description": $description;
    }""";
  }
}
