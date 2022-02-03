import 'package:flutter/material.dart';

class AnimatedLoadingIcon extends StatefulWidget {
  final Color? color;
  const AnimatedLoadingIcon({Key? key,this.color}) : super(key: key);

  @override
  _AnimatedLoadingIconState createState() => _AnimatedLoadingIconState();
}

class _AnimatedLoadingIconState extends State<AnimatedLoadingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this)
          ..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return RotationTransition(
        turns: _controller,
        child: Icon(
          Icons.refresh_rounded,
          color: widget.color ?? primary,
          size: 30,
        ));
  }
}
