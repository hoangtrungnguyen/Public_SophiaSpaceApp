import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/notes_provider.dart';

class NotesView extends StatefulWidget {
  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  ScrollController? _listController;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<NotesProvider>(context, listen: false).loadMoreNotes();
    });
  }

  @override
  void dispose() {
    _listController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_listController?.position.extentAfter == 0) {
      print("loadmore");
      Provider.of<NotesProvider>(context, listen: false).loadMoreNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      alignment: Alignment.center,
      child: Consumer<NotesProvider>(builder: (ctx, data, child) {
        return ListView.builder(
          controller: _listController,
          itemCount: data.notes.length,
          itemBuilder: (BuildContext context, int index) {
            return DailyNotes(
              note: data.notes[index],
            );
          },
        );
      }),
    );
  }
}

class DailyNotes extends StatelessWidget {
  final Note note;

  DailyNotes({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: Text("${note.title}"),
            subtitle: Text(
                "${note.timeCreated != null ? DateFormat.yMd().add_jm().format(note.timeCreated) : "NaN"} "),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: note.emotions.length > 0
                ? note.emotions.map((e) {
                    return Text(e.name ?? "NaN");
                    return Text('');
                  }).toList()
                : [],
          )
        ],
      ),
    );
  }
}
