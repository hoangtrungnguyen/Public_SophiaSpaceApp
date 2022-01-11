import 'package:flutter/widgets.dart';
import 'package:sophia_hub/model/daily_data.dart';
import 'package:sophia_hub/model/quote.dart';

class Data extends ChangeNotifier{
  List<DailyData> listData = [DailyData()];
  List<Quote> quotes = [];
}