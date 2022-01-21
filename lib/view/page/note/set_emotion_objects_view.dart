import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/emotion.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/view/page/note/set_note_details_view.dart';

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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, NoteDetailsView.nameRoute);
          },
          label: Text("Tiếp tục")),
      body: Column(
        children: [
          Spacer(
            flex: 1,
          ),
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
    print(note);
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _emotions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          Emotion emotion = _emotions[index];
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                if (note.emotions.contains(emotion)) {
                  note.emotions.remove(emotion);
                } else {
                  note.emotions.add(emotion);
                }
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(emotion.icon),
                    Text(
                      '${emotion.name}',
                    )
                  ]),
            ),
          );
        });
  }
}
