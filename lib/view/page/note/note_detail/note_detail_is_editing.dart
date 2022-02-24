import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/page/note/note_detail/activity_list.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

import 'emotion_status.dart';
import 'form_content.dart';
import 'slider_emotion_point.dart';

class EditingNoteDetails extends StatefulWidget {
  static const String nameRoute = "/NoteDetails";

  static Route<Note> route(Note note, NotesViewModel notesViewModel) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return MultiProvider(providers: [
        ChangeNotifierProvider<SingleNoteViewModel>(
            create: (_) => SingleNoteViewModel(note)),
        ChangeNotifierProvider<NotesViewModel>.value(
            value: notesViewModel,
        )
      ],
      builder: (context,child) =>EditingNoteDetails() ,
      // child: EditingNoteDetails(),
      );
    });
  }

  @override
  _EditingNoteDetailsState createState() => _EditingNoteDetailsState();
}

class _EditingNoteDetailsState extends State<EditingNoteDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
              onPressed: isWaiting
                  ? null
                  : () async {
                      NotesViewModel viewModel =
                          Provider.of<NotesViewModel>(context, listen: false);
                      SingleNoteViewModel single =
                          Provider.of<SingleNoteViewModel>(context,
                              listen: false);
                      bool isOk =
                          await viewModel.update(viewModel: single );
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
          title: Hero(
            tag: "appBarTitle",
            child:NoteDateTime(),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmotionStatus(),
                  SizedBox(
                    height: 20,
                  ),
                  SliderEmotionPoint(),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: ActivityList()),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: NoteFormContent()),
                ],
              )),
        ));
  }
}

class NoteDateTime extends StatelessWidget {
  const NoteDateTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Selector<SingleNoteViewModel, String>(
      selector: (context, model) =>
      "${DateFormat.yMd().add_jm().format(model.note.timeCreated)}",
      builder: (context, value, child) => Text(
        value,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

