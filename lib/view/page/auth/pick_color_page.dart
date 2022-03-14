import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/colors.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view_model/share_pref.dart';
import 'dart:math' as math;

class PickColorPage extends StatefulWidget {
  const PickColorPage({Key? key}) : super(key: key);

  @override
  _PickColorPageState createState() => _PickColorPageState();
}

class _PickColorPageState extends State<PickColorPage> {


  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6!.copyWith(
        color: Colors.white
    );
    return Scaffold(
      body: TweenAnimationBuilder(
        builder: (BuildContext context, double? radical, Widget? child) {

          return AnimatedContainer(
            duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      1.0,
                    ],
                    colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  )
              ),
              child: child!
          );
        },
        duration: Duration(seconds: 1),
        tween: Tween<double>(begin: 10,end: MediaQuery.of(context).size.width),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 24,),
              Text("Chọn màu của bạn",style: textStyle.copyWith(
                fontSize: 32
              ),),
              RegisterPickColorPage(),
              Spacer(),
              Center(
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true)
                          .pushNamedAndRemoveUntil( BaseContainer.nameRoute , (_)=> false);

                    },
                    style: ElevatedButtonTheme.of(context).style?.copyWith(
                        backgroundColor: MaterialStateProperty.all<Color?>(
                            Colors.white)),
                    child: Text("Tiếp tục",
                      style: textStyle.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                    ),)),
              ),

              SizedBox(height: 24,),
            ],
          ),
        ),
      ),
    );
  }
}



class RegisterPickColorPage extends StatefulWidget {



  RegisterPickColorPage({Key? key}) : super(key: key);

  @override
  _RegisterPickColorPageState createState() => _RegisterPickColorPageState();
}

class _RegisterPickColorPageState extends State<RegisterPickColorPage> {
  late PageController _controller;

  late MaterialColor pickedColor;

  double viewPortFraction = 0.4;



  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: viewPortFraction)
      ..addListener(_scrollListener);
    pickedColor = Provider.of<SharedPref>(context, listen: false).materialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: 400,
          margin: EdgeInsets.symmetric(vertical: 16),
        ),
        Positioned.fill(
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: themeColors.length,
            itemBuilder: _colorBuilder,
          ),
        )
      ],
    );
  }

  _scrollListener() {
    // print(_controller.page);
    // print(_controller);
    try {
      // print(_controller.);
      setState(() {
        curPage = _controller.page ?? 0;
      });
    } catch (e) {}
  }

  double curPage = 0;

  Widget _colorBuilder(BuildContext context, int index) {
    MaterialColor color = themeColors[index];
    // bool isPicked = color == pickedColor;
    double scale = math.max(
        viewPortFraction, (1 - (curPage - index).abs()) + viewPortFraction);

    Widget container = GestureDetector(
        onTap: () {
          setState(() {
            pickedColor = color;
            Provider.of<SharedPref>(context, listen: false).setColor(color);
          });
        },
        child: AnimatedContainer(
          margin: EdgeInsets.only(
              right: 30,
              left: 30,
              top: 100 - 50 * scale,
              bottom: 30 * scale
          ),
          decoration: ShapeDecoration(
            shape:
            CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [
                0.5,
                1.0,
              ],
              colors: [
                color.shade500,
                color.shade300,
              ],
            ),
            shadows: [
              BoxShadow(
                color: Colors.grey.shade50.withOpacity(0.2),
                spreadRadius: 1,
                offset: Offset(0.0, 4.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
          ),
          duration: Duration(milliseconds: 300),
        ));

    return container;
  }
}

