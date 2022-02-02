import 'package:flutter/material.dart';

class SophiaHubCloseButton extends StatelessWidget {
  final Color? color;
  final Color? iconColor;

  //TODO create var onPressed
  SophiaHubCloseButton({Key? key, this.color, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 12, right: 0),
        height: 50,
        width: 50,
        decoration: ShapeDecoration(
          shadows:  [
            BoxShadow(
              color: scheme.primary,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
            color: color ?? Colors.grey.shade200.withOpacity(0.5),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(32))),
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.close_rounded,
          color: iconColor ?? scheme.primary,),
        ));
  }
}
