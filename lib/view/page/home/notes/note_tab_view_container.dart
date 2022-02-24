import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view/page/home/notes/note_tab_view.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

class NoteTabViewContainer extends StatelessWidget {
  const NoteTabViewContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> NotesViewModel(),
      child: NoteTabView(),
    );
  }
}
