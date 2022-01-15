class Helper {
  static String generateTodayDailyDataId() => (DateTime.now().millisecondsSinceEpoch /
      (86400 * 1000))
      .round()
      .toString();

}

String generateTodayDailyDataId() => (DateTime.now().millisecondsSinceEpoch /
          (86400 * 1000))
      .round()
      .toString();

