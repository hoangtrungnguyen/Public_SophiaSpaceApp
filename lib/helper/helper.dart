String generateDailyDataId() => (DateTime.now().millisecondsSinceEpoch /
          (86400 * 1000))
      .round()
      .toString();


