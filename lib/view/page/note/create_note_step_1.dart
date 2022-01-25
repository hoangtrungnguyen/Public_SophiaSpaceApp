import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note.dart';

class EmotionPointView extends StatefulWidget {
  bool initial = true;

  static const String nameRoute = "/";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return EmotionPointView();
    });
  }

  @override
  _EmotionPointViewState createState() => _EmotionPointViewState();
}

class _EmotionPointViewState extends State<EmotionPointView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer2<Note, TabController>(
        builder: (BuildContext context, Note note, tabControl, Widget? child) {
          return FloatingActionButton.extended(

              elevation: !widget.initial ? 6 : 0,
              backgroundColor:
                  !widget.initial ? Colors.white : Colors.grey.withOpacity(0.3),
              onPressed: !widget.initial
                  ? () {
                      tabControl.animateTo(1,
                          duration: Duration(milliseconds: 1000));
                    }
                  : null,
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Tiếp tục",
                  style: Theme.of(context).textTheme.headline6?.apply(
                        color: widget.initial
                            ? Colors.grey.withOpacity(0.5)
                            : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ));
        },
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              "Bạn đang cảm thấy thế nào?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            Spacer(
              flex: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Consumer<Note>(builder: (_, note, child) {
                String status = '';

                if (widget.initial) return Text("");

                assert(note.emotionPoint >= 0 || note.emotionPoint < 10,
                    'Out of bound');
                status = generateMoodStatus(note.emotionPoint.toInt());
                return Text(
                  "$status",
                  style: Theme.of(context).textTheme.headline6,
                );
              }),
            ),
            Consumer(
              builder: (BuildContext context, Note note, Widget? child) {
                return Slider(
                  inactiveColor: Colors.grey.withOpacity(0.5),
                  activeColor: Colors.white,
                  value: widget.initial ? 5 : note.emotionPoint.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: "${note.emotionPoint}",
                  onChanged: (double value) {
                    note.emotionPoint = value.toInt();
                    widget.initial = false;
                    setState(() {});
                  },
                );
              },
            ),
            Spacer(
              flex: 5,
            )
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print("deactivate point view");
    super.deactivate();
  }
}
