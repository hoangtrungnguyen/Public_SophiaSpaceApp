import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/provider/note_state_manager.dart';
import 'package:sophia_hub/provider/single_note_state_manager.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';

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
    SingleNoteManager singleNoteManager =
        Provider.of<SingleNoteManager>(context);
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
                    "${DateFormat.yMd().add_jm().format(singleNoteManager.note.timeCreated)} "),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                children: singleNoteManager.note.activities.length > 0
                    ? singleNoteManager.note.activities.map((e) {
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
                  singleNoteManager.note.title = input;
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
                  singleNoteManager.note.description = input;
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
    NotesStateManager manager = Provider.of<NotesStateManager>(context,listen: false);
    SingleNoteManager singleNoteManager = Provider.of<SingleNoteManager>(context);
    return StreamBuilder<ConnectionState>(
      initialData: ConnectionState.done,
      stream: manager.appConnectionState,
      builder: (context, snapshot) {
        bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
        return FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () async {
            if (isWaiting) return;
            bool isOk =
            await Provider.of<NotesStateManager>(context, listen: false)
                .add(note: singleNoteManager.note);
            if (isOk)
              Navigator.of(context, rootNavigator: true).pop();
            else
              showErrMessage(context, manager.error!);
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
