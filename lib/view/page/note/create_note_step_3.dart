import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/notes_provider.dart';

class NoteDetailsView extends StatefulWidget {
  static const String nameRoute = "/NoteDetailsView";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return NoteDetailsView();
    });
  }

  @override
  _NoteDetailsViewState createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6?.apply(
      color: Colors.white
    );
    Color textColor = Colors.white;
    Note note = Provider.of<Note>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<Note>(
        builder: (BuildContext context, value, Widget? child) {
          Widget button;
          button = FloatingActionButton.extended(
            backgroundColor:  Colors.white,
            onPressed: () async {
              Result res =
                  await Provider.of<NotesProvider>(context, listen: false)
                  .addNote(note: note);
              if (res.data != null) {
                Navigator.of(context, rootNavigator: true).pop(true);
              } else {
                showDialog(
                    context: context,
                    builder: (_) {
                      return Card(child: Text("${res.error}"));
                    });
              }
            },
            label:  Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Hoàn thành check-in",
                style: Theme.of(context).textTheme.headline6?.apply(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),);
          return button;
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Form(
          child: Column(
            children: [
              Container(
                child: Text(
                    "${DateFormat.yMd().add_jm().format(note.timeCreated)} "),
              ),
              SizedBox(height: 20,),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                children: note.activities.length > 0
                    ? note.activities.map((e) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
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
                  );
                }).toList()
                    : [],
              ),
              SizedBox(height: 50,),
              TextFormField(
                decoration: InputDecoration(
                hintText: "Tiêu đề",),
                onChanged: (input) {
                  note.title = input;
                },
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                    // label: Text("Nội dung",style: TextStyle(color: textColor),),
                  hintText: "Suy nghĩ của bạn..."
                ),
                maxLines: 10,
                minLines: 3,
                style: TextStyle(color: textColor),
                onChanged: (input) {
                  note.description = input;
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
