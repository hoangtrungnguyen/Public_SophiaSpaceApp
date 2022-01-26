import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/note/create_note_step_2.dart';

class EditingNoteDetails extends StatefulWidget {
  static const String nameRoute = "/NoteDetails";

  static Route<dynamic> route(Note note) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return EditingNoteDetails.view(note);
    });
  }

  static Widget view(Note note) {
    return ChangeNotifierProvider<Note>.value(
      value: note,
      child: EditingNoteDetails(),
    );
  }

  @override
  _EditingNoteDetailsState createState() => _EditingNoteDetailsState();
}

class _EditingNoteDetailsState extends State<EditingNoteDetails> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Icon(Icons.done),
          onPressed: () async {
            try {
              Result result =
                  await Provider.of<NotesProvider>(context, listen: false)
                      .updateNote(note);
              if (result.isHasData) {
                Navigator.popUntil(context,
                    (route) => route.settings.name == BaseContainer.nameRoute);
              }
            } catch (e) {
              print("Lỗi");
            }
          },
        ),
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          leading: Container(),
          actions: [
            Hero(
              tag: "backButton",
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 26, right: 16, bottom: 26),
                  height: 50,
                  width: 50,
                  decoration: ShapeDecoration(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_rounded),
                  )),
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: Hero(
            tag: "appBarTitle",
            child: Text(
              "${DateFormat.yMd().add_jm().format(note.timeCreated)}",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        body: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<Note>(builder: (_, note, child) {
              String status = '';
              status = generateMoodStatus(note.emotionPoint.toInt());
              return Container(
                height: 120,
                child: Stack(
                  children: [
                    Align(
                      child: Icon(
                        generateMoodIcon(note.emotionPoint),
                        color: primary.withOpacity(0.1),
                        size: 80,
                      ),
                      alignment: Alignment(0, -0.2),
                    ),
                    Align(
                      child: Text(
                        "$status",
                        style:
                            Theme.of(context).textTheme.headline5?.copyWith(),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 20,
            ),
            SliderEmotionPoint(),
            ListEmotion(),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Hero(
                      tag: "title",
                      child: Material(
                        child: TextFormField(
                          initialValue: note.title,
                          decoration: InputDecoration(
                            hintText: "Tiêu đề",
                          ),
                          onChanged: (input) {
                            note.title = input;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Hero(
                      tag: "content",
                      child: Material(
                        child: TextFormField(
                          initialValue: note.description,
                          decoration: InputDecoration(
                              // label: Text("Nội dung",style: TextStyle(color: textColor),),
                              hintText: "Suy nghĩ của bạn..."),
                          maxLines: 10,
                          minLines: 3,
                          onChanged: (input) {
                            note.description = input;
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        )));
  }
}

class SliderEmotionPoint extends StatefulWidget {
  const SliderEmotionPoint({Key? key}) : super(key: key);

  @override
  _SliderEmotionPointState createState() => _SliderEmotionPointState();
}

class _SliderEmotionPointState extends State<SliderEmotionPoint> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    return Slider(
      inactiveColor: Colors.grey.withOpacity(0.5),
      activeColor: Theme.of(context).colorScheme.primary,
      value: note.emotionPoint.toDouble(),
      min: 0,
      max: 10,
      divisions: 10,
      label: "${note.emotionPoint}",
      onChanged: (double value) {
        note.point = value.toInt();
      },
    );
  }
}

class ListEmotion extends StatefulWidget {
  const ListEmotion({Key? key}) : super(key: key);

  @override
  _ListEmotionState createState() => _ListEmotionState();
}

class _ListEmotionState extends State<ListEmotion> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 16,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: ShapeDecoration(
                shape: roundedRectangleBorder,
                color: Theme.of(context).colorScheme.primary),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return ChangeNotifierProvider.value(
                          value: note,
                          child: Container(
                            height: 200,
                            child: Card(
                                child: Container(
                                    height: 200, child: EmotionGrid())),
                          ));
                    });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          ...note.activities.map((e) {
            return Hero(
              tag: "emotions ${e.id}",
              child: NoteActivityIcon(e),
            );
          }).toList(),
          SizedBox(
            width: 16,
          ),
        ]),
      ),
    );
  }
}

class NoteActivityIcon extends StatefulWidget {
  final Activity e;

  const NoteActivityIcon(this.e, {Key? key}) : super(key: key);

  @override
  State<NoteActivityIcon> createState() => _NoteActivityIconState();
}

class _NoteActivityIconState extends State<NoteActivityIcon> {
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        child: InputChip(
          deleteIcon: Icon(
            Icons.cancel_outlined,
            color: primary.withOpacity(0.5),
          ),
          onDeleted: () {
            print('deleted');
            Provider.of<Note>(context, listen: false).removeEmotion(widget.e);
          },
          elevation: 4,
          backgroundColor: Colors.white,
          avatar: Icon(
            widget.e.icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: Text(
            widget.e.name ?? "NaN",
            style:
                Theme.of(context).textTheme.caption?.copyWith(color: primary),
          ),
        ),
      ),
    );
  }
}
