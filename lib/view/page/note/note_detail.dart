import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/view/page/note/note_detail_is_editing.dart';

class NoteDetails extends StatefulWidget {
  static const String nameRoute = "/NoteDetails";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return NoteDetails();
    });
  }

  static Widget view(Note note, {Key? key}) {
    Note copied = note.copy();
    return ChangeNotifierProvider<Note>(
      create: (_) {
        return copied;
      },
      child: NoteDetails(),
    );
  }

  NoteDetails({Key? key}) : super(key: key);

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    Color primary = Theme.of(context).colorScheme.primary;
    final head4 = Theme.of(context).textTheme.headline4?.copyWith(
        color: primary.withOpacity(0.3), fontWeight: FontWeight.bold);
    final head6 = Theme.of(context).textTheme.headline6?.copyWith(
        color: primary.withOpacity(0.3), fontWeight: FontWeight.bold);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Icon(Icons.edit_outlined),
          onPressed: () {
            Navigator.push(context, EditingNoteDetails.route(note));
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
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.grey.shade400),
            ),
          ),
        ),
        body: Container(
            child: Column(
          children: [
            Container(
              height: 210,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                      top: size.width / 28,
                      bottom: size.width / 8.2,
                      left: size.width / 3.8,
                      right: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Trạng thái', style: head4),
                            Text("Hoạt động", style: head4),
                          ])),
                  Align(
                    alignment: Alignment(-1.3, -0.5),
                    child: Hero(
                      tag: "mood icon",
                      child: Icon(
                        generateMoodIcon(note.emotionPoint),
                        color: primary.withOpacity(0.1),
                        size: 130,
                      ),
                    ),
                  ),
                  Positioned(
                      left: size.width / 4,
                      // right: size.width/4,
                      top: 45,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Hero(
                            tag: "mood text",
                            child: Text(
                              "${generateMoodStatus(note.emotionPoint)}",
                              style: head6?.copyWith(color: primary),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        SizedBox(
                          width: size.width / 4,
                        ),
                        ...note.activities.map((e) {
                          return Hero(
                            tag: "emotions ${e.id}",
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 8, right: 8, bottom: 8),
                              child: Material(
                                color: Colors.transparent,
                                child: Chip(
                                    backgroundColor: Colors.transparent,
                                    avatar: Icon(
                                      e.icon,
                                      color: primary,
                                    ),
                                    label: Text(
                                      e.name ?? "NaN",
                                    )),
                              ),
                            ),
                          );
                        }).toList(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //TextField
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Builder(
                builder: (BuildContext context) {
                  return Material(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Builder(
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              Hero(
                                tag: "title",
                                child: Material(
                                  child: TextFormField(
                                      readOnly: true,
                                      initialValue: note.title,
                                      decoration:
                                          InputDecoration(hintText: "Tiêu đề"),
                                      onChanged: null),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Hero(
                                tag: "content",
                                child: Material(
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                          // label: Text("Nội dung",style: TextStyle(color: textColor),),
                                          hintText: "Suy nghĩ của bạn..."),
                                      maxLines: 10,
                                      minLines: 3,
                                      readOnly: true,
                                      initialValue: note.description,
                                      onChanged: null),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )));
  }
}
