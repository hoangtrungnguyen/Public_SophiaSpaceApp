import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

import 'editing_activity_list.dart';
import 'editing_date_time.dart';
import 'editing_form_content.dart';
import 'editing_slider_emotion_point.dart';
import 'editting_emotion_status.dart';

class EditingSingleNoteViewModel extends SingleNoteViewModel {
  EditingSingleNoteViewModel(GenericNote note) : super(note);
}

class EditingNoteDetails extends StatefulWidget {
  static const String nameRoute = "/NoteDetailsEditing";

  static Route<Note> route(Note note, NotesViewModel notesViewModel) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<NotesViewModel>.value(
            value: notesViewModel,
          ),
          ChangeNotifierProvider<EditingSingleNoteViewModel>(
              create: (_) => EditingSingleNoteViewModel(note.copyContent())),
        ],
        // builder: (context, child) => EditingNoteDetails(),
        child: EditingNoteDetails(key: ValueKey("Editing")),
      );
    });
  }

  EditingNoteDetails({Key? key}) : super(key: key);

  @override
  _EditingNoteDetailsState createState() => _EditingNoteDetailsState();
}

class _EditingNoteDetailsState extends State<EditingNoteDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Selector<NotesViewModel, ConnectionState>(
          selector: (_, viewModel) => viewModel.appConnectionState,
          builder: (context, data, child) {
            bool isWaiting = data == ConnectionState.waiting;
            return FloatingActionButton(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: isWaiting
                  ? AnimatedLoadingIcon(
                      color: Colors.white,
                    )
                  : Icon(Icons.done),
              onPressed: () async {
                if (isWaiting) return;
                NotesViewModel viewModel =
                    Provider.of<NotesViewModel>(context, listen: false);
                EditingSingleNoteViewModel single =
                    Provider.of<EditingSingleNoteViewModel>(context,
                        listen: false);
                bool isOk = await viewModel.update(note: single.note);
                if (isOk) {
                  Navigator.of(context).pop<Note?>(single.note as Note);
                } else {
                  showErrMessage(context, viewModel.error!);
                }
              },
            );
          },
        ),
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          leading: Container(),
          actions: [
            Hero(
              tag: "backButton",
              child: Material(
                  shape: continuousRectangleBorder,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop<Note?>(context);
                    },
                    child: Icon(Icons.close_rounded),
                  )),
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: NoteDateTime(),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmotionStatus(),
                  SizedBox(height: 20),
                  SliderEmotionPoint(),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: EditingActivityList()),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: NoteFormContent()),
                ],
              )),
        ));
  }
}
