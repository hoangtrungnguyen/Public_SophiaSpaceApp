import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/single_note_view_model.dart';
import 'package:sophia_hub/view_model/single_note_view_model.dart';

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
    SingleNoteViewModel viewModel =
        Provider.of<SingleNoteViewModel>(context);
    Note note = (viewModel.note as Note);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AddButton(),
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
              SizedBox(
                height: 20,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                children: note.activities != null
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
              SizedBox(
                height: 50,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Tiêu đề",
                ),
                onChanged: (input) {
                  note.title = input;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                    // label: Text("Nội dung",style: TextStyle(color: textColor),),
                    hintText: "Suy nghĩ của bạn..."),
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

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    NotesViewModel notes = Provider.of<NotesViewModel>(context,listen: false);
    SingleNoteViewModel single = Provider.of<SingleNoteViewModel>(context);
    return Selector<NotesViewModel, ConnectionState>(
      selector: (_, viewModel) => viewModel.appConnectionState,
      builder: (context, data, child) {
        bool isWaiting = data == ConnectionState.waiting;
        return FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () async {
            if (isWaiting) return;
            bool isOk =
            await Provider.of<NotesViewModel>(context, listen: false)
                .add(note: single.note);
            if (isOk)
              Navigator.of(context, rootNavigator: true).pop(true);
            else
              showErrMessage(context, notes.error!);
          },
          label: Container(
            width: 350,
            alignment: Alignment.center,
            child: isWaiting
                ? AnimatedLoadingIcon()
                : Text(
              "Hoàn thành check-in",
              style: Theme.of(context).textTheme.headline6?.apply(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
