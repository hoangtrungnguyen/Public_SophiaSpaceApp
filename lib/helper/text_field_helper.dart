import 'package:flutter/material.dart';
import 'package:sophia_hub/constant/theme.dart';

class TextFieldHelper {
  static Widget buildCounter(_,
      {
        required int currentLength,
        required int? maxLength,
        required bool isFocused,
      }) {
    return LayoutBuilder(
      builder: (BuildContext context,
          BoxConstraints constraints) {
        double height = constraints.maxHeight;
        double width = constraints.maxWidth;
        // print(height);
        // print(width);
        return Transform(
            transform: Matrix4.translationValues(
                width / 20,  -width/4, 0),
            child: Material(
                elevation: 4,
                type: MaterialType.card,
                shape: continuousRectangleBorder,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2, horizontal: 5),
                    child: Text(
                      "${currentLength}/${maxLength}",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),))));
      },
    );
  }
}