import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    listTileTheme: ListTileTheme.of(context).copyWith(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.all(10) ,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    )
  );
}
