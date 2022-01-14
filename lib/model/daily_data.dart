import 'package:flutter/cupertino.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/quote.dart';
import 'package:sophia_hub/model/task.dart';

class DailyData with ChangeNotifier {
  String id;
  DateTime time;
  List<Task> tasks = [];
  List<Note> diaryNotes = [];
  Quote quote;

}