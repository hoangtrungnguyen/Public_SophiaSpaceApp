import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/view/page/note/set_emotion_objects_view.dart';

class EmotionPointView extends StatefulWidget {
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
  double _emotionPoint = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<Note>(
        builder: (BuildContext context, Note note, Widget? child) {
          return FloatingActionButton.extended(
              onPressed: note.emotionPoint != null
                  ? () {
                      Navigator.pushNamed(
                          context, EmotionObjectsView.nameRoute);
                    }
                  : null,
              label: Text("Tiếp tục"));
        },
      ),
      body: Container(
        child: Column(
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              "Bạn đang cảm thấy như nào?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            Spacer(
              flex: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Builder(builder: (_) {
                String status = '';
                assert(_emotionPoint >= 0 || _emotionPoint < 10);
                if (2 > _emotionPoint && _emotionPoint >= 0) {
                  status = "Rất tệ";
                } else if (4 > _emotionPoint && _emotionPoint >= 2) {
                  status = "Hơi tệ";
                } else if (5 > _emotionPoint && _emotionPoint >= 4) {
                  status = "Tạm ổn";
                } else if (7 > _emotionPoint && _emotionPoint >= 5) {
                  status = "Tốt";
                } else if (9 > _emotionPoint && _emotionPoint >= 7) {
                  status = "Rất tốt";
                } else {
                  status = "Tuyệt vời";
                }
                return Text(
                  "${status}",
                  style: Theme.of(context).textTheme.headline6,
                );
              }),
            ),
            Consumer(
              builder: (BuildContext context, Note note, Widget? child) {
                return Slider(
                  value: _emotionPoint,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: "$_emotionPoint",
                  onChanged: (double value) {
                    note.emotionPoint = value.toInt();
                    setState(() {
                      _emotionPoint = value;
                    });
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
}
