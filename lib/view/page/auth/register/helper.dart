import 'package:flutter/material.dart';

class RegisterHelper {
  int subStep = 0;

  Widget buildText(String text,int step, TextStyle textStyle){
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 1000),
      style: (){
        if(subStep > step)
          return textStyle.copyWith(color: Colors.white.withOpacity(0.5));
        else if (subStep == step)
          return textStyle.copyWith(color: Colors.white);
        else
          return textStyle.copyWith(color: Colors.transparent);

      }(),
      child: Text("$text"),
    );
  }
}