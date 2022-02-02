import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SharePref extends ChangeNotifier{

  late MaterialColor materialColor;



  Future<void> init() async {
    this.materialColor = Colors.indigo;
  }

  void setColor(MaterialColor color) {
    materialColor = color;
    notifyListeners();
  }
}