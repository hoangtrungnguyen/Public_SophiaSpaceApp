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
    duration: Duration(seconds: 3))..forward()..addListener(() {
      if(_controller.isCompleted) {
        _controller.reverse();
      } else if(_controller.isDismissed){
        _controller.forward();
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller.drive(Tween<double>(begin: 0.95,end: 1)),
      child: RotationTransition(
        turns: _controller,
        child: Opacity(
          opacity: 0.4,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.2,
                  1.0,
                ],
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
              )
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
      ),
    );
  }
}
