import 'package:flutter/material.dart';
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
    Note note = Provider.of<Note>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("Tiêu đề")),
                style: TextStyle(),
                onChanged: (input) {
                  note.title = input;
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text("Nội dung")),
                maxLines: 10,
                minLines: 3,
                style: TextStyle(),
                onChanged: (input) {
                  note.description = input;
                },
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    Result res =
                        await Provider.of<NotesProvider>(context, listen: false)
                            .addNote(note: note);
                    if (res.data != null) {
                      Provider.of<NotesProvider>(context, listen: false)
                          .loadMoreNotes();
                      Navigator.of(context, rootNavigator: true).pop(true);
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Card(child: Text("${res.error}"));
                          });
                    }
                  },
                  child: Text("Thêm note"))
            ],
          ),
        ),
      ),
    );
  }
}
