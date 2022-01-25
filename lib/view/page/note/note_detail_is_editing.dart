import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note.dart';

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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Icon(Icons.done),
          onPressed: () {},
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
          children: [
            Consumer<Note>(builder: (_, note, child) {
              String status = '';
              status = generateMoodStatus(note.emotionPoint.toInt());
              return Text(
                "$status",
                style: Theme.of(context).textTheme.headline6,
              );
            }),
            SizedBox(height: 20,),
            Consumer(
              builder: (BuildContext context, Note note, Widget? child) {
                return Slider(

                  inactiveColor: Colors.grey.withOpacity(0.5),
                  activeColor: Theme.of(context).colorScheme.primary,
                  value:  note.emotionPoint.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: "${note.emotionPoint}",
                  onChanged: (double value) {
                    note.point = value.toInt();
                  },
                );
              },
            ),
            Wrap(
              children: note.emotions.length > 0
                  ? note.emotions.map((e) {
                      return Hero(
                        tag: "emotions ${e.id}",
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Material(
                            child: ActionChip(
                              elevation: 6,
                              backgroundColor: Colors.white,
                              avatar: Icon(
                                e.icon,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              label: Text(
                                e.name ?? "NaN",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  : [],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Builder(
                builder: (BuildContext context) {
                  return Column(
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
                  );
                },
              ),
            ),
          ],
        )));
  }
}
