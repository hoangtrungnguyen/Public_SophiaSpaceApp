import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ShapeBorder roundedRectangleBorder = ContinuousRectangleBorder(
  borderRadius: BorderRadius.circular(28.0),
);

ColorScheme getColorScheme(
  BuildContext context, {
  MaterialColor color: Colors.red,
}) {
  final primary = color[700];
  final secondary = color[400];
  return Theme.of(context).colorScheme.copyWith(
        primary: primary,
        secondary: secondary,


      );
}

TextTheme getTextTheme(BuildContext context, {String fontName = "Dongle"}) {
  //Comfortaa
  //Varela Round
  return GoogleFonts.varelaTextTheme();
}

ThemeData lightTheme(BuildContext context) {
  ThemeData themeData = Theme.of(context).copyWith(
      colorScheme: getColorScheme(context),
      textTheme: getTextTheme(context, fontName: 'Nunito'));

  themeData = themeData.copyWith(
    chipTheme: ChipTheme.of(context).copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical:12,
        horizontal: 12,
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
      ),
      labelStyle: TextStyle(
        decorationColor: Colors.red,
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme.of(context).copyWith(),
    bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
      elevation: 100,
    ),
    listTileTheme: ListTileTheme.of(context).copyWith(
      shape: roundedRectangleBorder,
    ),
    floatingActionButtonTheme: Theme.of(context)
        .floatingActionButtonTheme
        .copyWith(
            shape: roundedRectangleBorder,
            backgroundColor: getColorScheme(context).primary),
    cardTheme: Theme.of(context).cardTheme.copyWith(
          margin: EdgeInsets.all(10),
          shape: roundedRectangleBorder,
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color?>(Colors.white) ,
            shape: MaterialStateProperty.all<OutlinedBorder?>(
                roundedRectangleBorder as OutlinedBorder))),
  );

  return themeData;
}

ThemeData? darkTheme(BuildContext context) {}
