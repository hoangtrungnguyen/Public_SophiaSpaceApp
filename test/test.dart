
import 'package:intl/intl.dart';

main() {
  DateTime aDateTime = DateTime.now();
  print(DateFormat.yMMMMEEEEd().format(aDateTime));
  // ==> 'Wednesday, January 10, 2012'
  print(DateFormat('EEEEE', 'en_US').format(aDateTime));
  // ==> 'Wednesday'
  print(DateFormat('EEEEE', 'ln').format(aDateTime));
  // ==> 'mokɔlɔ mwa mísáto'
}