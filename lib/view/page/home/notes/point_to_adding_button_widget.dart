import 'package:flutter/material.dart';

class PointToAddingNotesWidget extends StatefulWidget {
  const PointToAddingNotesWidget({Key? key}) : super(key: key);

  @override
  _PointToAddingNotesWidgetState createState() => _PointToAddingNotesWidgetState();
}

class _PointToAddingNotesWidgetState extends State<PointToAddingNotesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _controller = AnimationController(vsync: this,
    duration: Duration(milliseconds: 800))..forward()..addListener(() {
      if(_controller.isCompleted){
        _controller.reverse();
      } else if(_controller.isDismissed){
        _controller.forward();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _controller.drive(Tween<Offset>(
          begin: Offset.zero,
          end: Offset(0,0.5)
        )),
      child: Icon(Icons.arrow_downward_rounded,size: 50,
      color: Theme.of(context).colorScheme.primary,),
    );
  }
}
