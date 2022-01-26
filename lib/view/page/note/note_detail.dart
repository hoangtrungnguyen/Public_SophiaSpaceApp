import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/view/page/note/note_detail_is_editing.dart';

class NoteDetails extends StatefulWidget {
  static const String nameRoute = "/NoteDetails";


  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return NoteDetails();
    });
  }

  static Widget view(Note note,{Key? key}) {
    Note copied = note.copy();
    return ChangeNotifierProvider<Note>(
      create: (_) {
        return copied;
      },
      child:NoteDetails(),
    );
  }

  NoteDetails({Key? key}):super(key: key);

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
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
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 32,),
                  ...note.activities.map((e) {
                  return Hero(
                    tag: "emotions ${e.id}",
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Material(
                        child: Chip(
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
                            )),
                      ),
                    ),
                  );
                }).toList(),
          ]
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
