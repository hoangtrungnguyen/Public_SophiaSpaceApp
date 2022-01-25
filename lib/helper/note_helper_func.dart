String generateMoodStatus(int _emotionPoint) {
  String status;
  assert(_emotionPoint >= 0 || _emotionPoint < 10, 'Out of bound');
  if (2 > _emotionPoint && _emotionPoint >= 0) {
    status = "Rất tệ";
  } else if (4 > _emotionPoint && _emotionPoint >= 2) {
    status = "Hơi tệ";
  } else if (5 > _emotionPoint && _emotionPoint >= 4) {
    status = "Tạm ổn";
  } else if (7 > _emotionPoint && _emotionPoint >= 5) {
    status = "Tốt";
  } else if (9 > _emotionPoint && _emotionPoint >= 7) {
    status = "Rất tốt";
  } else {
    status = "Tuyệt vời";
  }

  return status;
}
