import 'package:flutter/material.dart';

List<MaterialColor> themeColors = (){
  final themes =  List.of(Colors.primaries)..remove(Colors.yellow);
  return themes;
}();