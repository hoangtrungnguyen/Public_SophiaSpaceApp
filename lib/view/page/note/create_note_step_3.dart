import 'package:another_flushbar/flushbar.dart';
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
    Color textColor = Colors.white;
    Note note = Provider.of<Note>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  StreamBuilder<bool>(
        initialData: false,
        stream: Provider.of<NotesPublisher>(context,listen: false).isLoadingPublisher,
        builder: (context,snapshot){
          return FloatingActionButton.extended(
            backgroundColor:  Colors.white,
            onPressed: snapshot.data! ? null: () async {
              Result res =
              await Provider.of<NotesPublisher>(context, listen: false)
                  .addNote(note: note);
              if (res.data != null) {
                int index = res.data['addedIndex'];
                Navigator.of(context, rootNavigator: true).pop(index);
              } else {
                Flushbar(
                  backgroundColor:
                  Theme.of(context).colorScheme.error,
                  message: res.error.toString(),
                  flushbarPosition: FlushbarPosition.TOP,
                  borderRadius: BorderRadius.circular(16),
                  margin: EdgeInsets.all(8),
                  duration: Duration(seconds: 3),
                )..show(context);
              }
            },
            label:  Container(
              width: 350,
              alignment: Alignment.center,
              child: snapshot.data! ? Icon(Icons.refresh,color: Theme.of(context).colorScheme.primary,): Text(
                "Hoàn thành check-in",
                style: Theme.of(context).textTheme.headline6?.apply(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),);
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
