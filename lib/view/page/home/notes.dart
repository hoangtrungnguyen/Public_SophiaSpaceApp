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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      alignment: Alignment.center,
      child: Consumer<AppData>(builder: (ctx, data, child) {

        return Column(
          children: data.notes.map((e) => Text("${e.title}")).toList(),
        );
      }),
    );
  }
}

class ListNotes extends StatefulWidget {
  @override
  _ListNotesState createState() => _ListNotesState();
}

class _ListNotesState extends State<ListNotes> {


  @override
  Widget build(BuildContext context) {


    return ListView(
      children: [],
    );

  }


}
