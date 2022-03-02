import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note/note_regular.dart';

import 'note_detail_is_editing.dart';

class NoteDateTime extends StatefulWidget {
  const NoteDateTime({Key? key}) : super(key: key);

  @override
  State<NoteDateTime> createState() => _NoteDateTimeState();
}

class _NoteDateTimeState extends State<NoteDateTime> {
  @override
  Widget build(BuildContext context) {
    EditingSingleNoteViewModel viewModel = Provider.of<EditingSingleNoteViewModel>(context);
    Note note = viewModel.note as Note;
    return Hero(
      tag: "appBarTitle",
      child: Text(
        "${DateFormat.yMd().add_jm().format(note.timeCreated)}",
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
