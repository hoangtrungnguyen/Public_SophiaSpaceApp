import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ShapeBorder continuousRectangleBorder = ContinuousRectangleBorder(
  borderRadius: BorderRadius.circular(28.0),
);

ShapeDecoration commonDecoration(Color color) =>
    ShapeDecoration(
        color: color,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(32)));

ShapeDecoration commonDecorationShadow = ShapeDecoration(
  shape: continuousRectangleBorder,
  color: Colors.white,
  shadows: [
    BoxShadow(
      color: Colors.grey,
      offset: Offset(0.0, 1.0), //(x,y)
      blurRadius: 4.0,
    ),
  ],
);

ColorScheme getColorScheme(BuildContext context, {
  MaterialColor color: Colors.indigo,
}) {
  final primary = color[600];
  final secondary = color[300];
  return Theme
      .of(context)
      .colorScheme
      .copyWith(
      primary: primary,
      secondary: secondary,
      background: color[50],
      error: Colors.redAccent[100]);
}

TextTheme getTextTheme(BuildContext context, {String fontName = "Dongle"}) {
  //Comfortaa
  //Varela Round
  return GoogleFonts.varelaTextTheme();
}

ThemeData lightTheme(BuildContext context, MaterialColor materialColor) {
  ColorScheme colorScheme = getColorScheme(context,color: materialColor);
  ThemeData themeData = Theme.of(context)
      .copyWith(colorScheme: colorScheme, textTheme: getTextTheme(context));

  themeData = themeData.copyWith(
    // shadowColor: (){
    //   Color primary = colorScheme.primary;
    //   int blue = primary.blue;
    //   int green = primary.green;
    //   int red = primary.red;
    //
    //   return Color.fromRGBO((red).toInt(), (green ~/ 1.1).toInt(),
    //       (blue ~/ 1.1).toInt(), 0.5);
    // }(),

    dialogTheme:
    DialogTheme.of(context).copyWith(shape: continuousRectangleBorder),
    chipTheme: ChipTheme.of(context).copyWith(
      elevation: 4,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      labelStyle: themeData.textTheme.headline5
          ?.copyWith(color: themeData.colorScheme.primary),
      secondaryLabelStyle: themeData.textTheme.headline5
          ?.copyWith(color: themeData.colorScheme.primary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(14)),
      disabledBorder: InputBorder.none,
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme
              .of(context)
              .colorScheme
              .error),
          borderRadius: BorderRadius.circular(14)),
      suffixIconColor: Colors.white.withOpacity(0.8),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      filled: true,
      labelStyle: TextStyle(
        decorationColor: Theme
            .of(context)
            .colorScheme
            .error,
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme.of(context).copyWith(),
    bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
      elevation: 100,
    ),
    listTileTheme: ListTileTheme.of(context).copyWith(
      shape: continuousRectangleBorder,
    ),
    floatingActionButtonTheme: Theme
        .of(context)
        .floatingActionButtonTheme
        .copyWith(
        shape: continuousRectangleBorder,
        backgroundColor: colorScheme.primary),
    cardTheme: Theme
        .of(context)
        .cardTheme
        .copyWith(
      margin: EdgeInsets.all(10),
      elevation: 4,
      shape: continuousRectangleBorder,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.all<Color?>(Colors.white) ,
            shape: MaterialStateProperty.all<OutlinedBorder?>(
                continuousRectangleBorder as OutlinedBorder))),
  );

  return themeData;
}

ThemeData? darkTheme(BuildContext context) {}
