import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:sophia_hub/model/daily_data.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/quote.dart';

class AppData extends ChangeNotifier {
  List<DailyData> listData = [];
  List<Quote> quotes = [];

  AppData() {
    Future.microtask(() async{
          //Lấy dữ liều từ server và thêm vào danh sách
           await Future.delayed(Duration(seconds: 2),);
           listData.addAll([
             DailyData()..time = DateTime.now().subtract(Duration(days: 2)),
             DailyData()..time = DateTime.now().subtract(Duration(days: 3))
           ]);
          //Thêm phần từ dữ liệu ngày hôm nay nếu không có
          listData.add(
            DailyData()..time = DateTime.now()
          );
          notifyListeners();
        });
  }

  addNote(Note note) async {
    //lấy ngày hiện tại và thêm note
    listData[0].diaryNotes.add(note);
  }
}
