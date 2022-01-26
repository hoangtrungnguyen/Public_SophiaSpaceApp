import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  late MaterialColor color;

  ThemeProvider(){
    this.color = Colors.indigo;
  }


}