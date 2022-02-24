import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SingleNoteViewModel viewModel = Provider.of<SingleNoteViewModel>(
      context
    );
    Note note =  (viewModel.note as Note);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<TabController>(
        builder: (BuildContext context, tabControl, Widget? child) {
          return FloatingActionButton.extended(
              elevation: note.emotionPoint != null ? 4 : 0,
              backgroundColor:
              note.emotionPoint != null ? Colors.white : Colors.grey.withOpacity(0.3),
              onPressed: note.emotionPoint != null
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
                        color: note.emotionPoint != null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.withOpacity(0.5),
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
              flex: 3,
            ),
            note.emotionPoint == null ?
            Icon(FontAwesomeIcons.grin,color: Colors.grey,size: 70,)
                : Icon( generateMoodIcon(note.emotionPoint ?? 5),
            color: Colors.white,
            size: 80,),
            Padding(
              padding: EdgeInsets.only(bottom: 50,top: 15),
              child: Builder(builder: (
                _,
              ) {
                String status = '';

                if (note.emotionPoint == null) return Text("");

                status = generateMoodStatus(note.emotionPoint?.toInt() ?? 5);
                return Text(
                  "$status",
                  style: Theme.of(context).textTheme.headline6,
                );
              }),
            ),
           Slider(
                  inactiveColor: Colors.grey.withOpacity(0.5),
                  activeColor: Colors.white,
                  value: (note.emotionPoint ?? 5).toDouble() ,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: "${note.emotionPoint}",
                  onChanged: (double value) {
                    viewModel.setEmotionPoint(value.toInt());
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
    super.deactivate();
  }
}
