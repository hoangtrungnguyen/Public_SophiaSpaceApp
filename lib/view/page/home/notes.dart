import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/app_data.dart';

class NotesView extends StatefulWidget {
  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  ScrollController _listController;


  @override
  void initState() {
    super.initState();
    _listController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _listController.removeListener(_scrollListener);
    super.dispose();
  }


  void _scrollListener() {
    if (_listController.position.extentAfter == 0) {
        print("loadmore");
        Provider.of<AppData>(context,listen: false).loadMoreNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      alignment: Alignment.center,
      child: Consumer<AppData>(builder: (ctx, data, child) {

        return ListView.builder(
          controller:_listController ,
          itemCount: data.notes.length,
          itemBuilder: (BuildContext context, int index) {
            return DailyNotes(note: data.notes[index],);
          },
        );
      }),
    );
  }
}

class DailyNotes extends StatefulWidget {
  final Note note;
  DailyNotes({this.note});

  @override
  _DailyNotesState createState() => _DailyNotesState();
}

class _DailyNotesState extends State<DailyNotes> {


  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        title: Text("${widget.note.title}"),
        subtitle: Text("${widget.note.description}"),
      ),
    );

  }


}
