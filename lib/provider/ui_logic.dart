import 'package:flutter/cupertino.dart';

class UILogic extends ChangeNotifier{
  int _homePageIndex = 0;

  int get homePageIndex => _homePageIndex;

  //Chỉ cho phép đặt Id một lần
  set homePageIndex(int index) {
    _homePageIndex = index;
    notifyListeners();
  }



}