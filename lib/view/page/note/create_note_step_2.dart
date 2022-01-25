import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/emotion.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/view/page/note/create_note_step_3.dart';

class EmotionObjectsView extends StatefulWidget {
  static const String nameRoute = "/EmotionObjectsView";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return EmotionObjectsView();
    });
  }

  @override
  _EmotionObjectsViewState createState() => _EmotionObjectsViewState();
}

class _EmotionObjectsViewState extends State<EmotionObjectsView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<Note>(
        builder: (BuildContext context, value, Widget? child) {
          Widget button;
          button = FloatingActionButton.extended(
             elevation: value.emotions.length <= 0 ? 0 : 6,
              backgroundColor: value.emotions.length <= 0
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.white,
              onPressed: value.emotions.length <= 0
                  ? null
                  : () {
                    Provider.of<TabController>(context,listen: false).animateTo(2,
                    duration: Duration(milliseconds: 1000));
                  },
              label:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Tiếp tục",
                  style: Theme.of(context).textTheme.headline6?.apply(
                    color: value.emotions.length <= 0
                        ? Colors.grey.withOpacity(0.5)
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),);
          return button;
        },
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Text(
            "Điều gì khiến bạn cảm thấy như vậy?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          Spacer(
            flex: 4,
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            child: EmotionGrid(),
          ),
          Spacer(
            flex: 5,
          )
        ],
      ),
    );
  }

  @override
  void deactivate() {
    print("deactivate emotion view");
    super.deactivate();
  }
}

class EmotionGrid extends StatefulWidget {
  const EmotionGrid({Key? key}) : super(key: key);

  @override
  _EmotionGridState createState() => _EmotionGridState();
}

class _EmotionGridState extends State<EmotionGrid> {
  List<Emotion> _emotions = emotions;

  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _emotions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          Emotion emotion = _emotions[index];
          bool isChosen = note.emotions.contains(emotion);
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor:
                MaterialStateProperty.all<Color?>(isChosen ? Theme.of(context).colorScheme.primary : Colors.grey)
              ),
              onPressed: () {
                if (isChosen) {
                  note.removeEmotion(emotion);
                } else {
                  note.addEmotion(emotion);
                }
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(emotion.icon),
                    Text(
                      '${emotion.name}',
                      textAlign: TextAlign.center,
                    )
                  ]),
            ),
          );
        });
  }
}
