import 'package:flutter/material.dart';
import 'package:sophia_hub/constant/theme.dart';

class SpinningRing extends StatefulWidget {
  const SpinningRing({Key? key}) : super(key: key);

  @override
  _SpinningRingState createState() => _SpinningRingState();
}

class _SpinningRingState extends State<SpinningRing> with SingleTickerProviderStateMixin{

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
    duration: Duration(seconds: 3))..repeat();
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Opacity(
        opacity: 0.2,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: backgroundLinearGradient(context)
          ),
          height: 300,
          width: 300,
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
        ),
      ),
    );
  }
}
