import 'dart:ui';

Color shadingForegroundColor(Color color, {double darkenValue = 0.6}) {
  assert(darkenValue <= 1);
  int r = (color.red * darkenValue).toInt();
  int g = (color.green * darkenValue).toInt();
  int b = (color.blue * darkenValue).toInt();

  return Color.fromRGBO(r, g, b, 0.6);
}
