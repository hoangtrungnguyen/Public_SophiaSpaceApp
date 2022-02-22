import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
//https://fontawesome.com/v5.15/icons?d=gallery&p=2&q=face
IconData generateMoodIcon(int _emotionPoint){
  IconData statusIcon;
  if (2 > _emotionPoint && _emotionPoint >= 0) {
    statusIcon = FontAwesomeIcons.frown;
  } else if (4 > _emotionPoint && _emotionPoint >= 2) {
    statusIcon = FontAwesomeIcons.frownOpen;
  } else if (5 > _emotionPoint && _emotionPoint >= 4) {
    statusIcon = FontAwesomeIcons.meh;
  } else if (7 > _emotionPoint && _emotionPoint >= 5) {
    statusIcon = FontAwesomeIcons.grin;
  } else if (9 > _emotionPoint && _emotionPoint >= 7) {
    statusIcon = FontAwesomeIcons.grinBeam;
  } else {
    statusIcon = FontAwesomeIcons.grinStars;
  }

  return statusIcon;
}
