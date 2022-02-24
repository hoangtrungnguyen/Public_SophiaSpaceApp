import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/page/home/notes/note_tab_single_item_content.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';


class NoteTabAnimatedListView extends StatefulWidget {
  const NoteTabAnimatedListView({Key? key}) : super(key: key);

  @override
  State<NoteTabAnimatedListView> createState() => _NoteTabAnimatedListViewState();
}

class _NoteTabAnimatedListViewState extends State<NoteTabAnimatedListView> {

  final listKey = GlobalObjectKey<AnimatedListState>("key");

  @override
  void initState() {
    Provider.of<NotesViewModel>(context, listen: false).listKey = listKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget groupListView = AnimatedList(
      key: listKey,
      initialItemCount: Provider.of<NotesViewModel>(context,listen: false).notes.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: _buildSingleItem,
    );


    return groupListView;

  }

  Widget _buildSingleItem(
      BuildContext context, int index, Animation<double> animation) {
    Widget main = NoteItem(index);
    return FadeTransition(
        opacity: animation.drive(Tween<double>(begin: 0, end: 1)), child: main);
  }

}

class NoteItem extends StatefulWidget {

  final int index;

  NoteItem(this.index, {Key? key, }) : super(key: key);

  @override
  _NoteItemState createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {


  @override
  Widget build(BuildContext context) {
         NotesViewModel viewModel = Provider.of<NotesViewModel>(context);
    SingleNoteViewModel singleNote = viewModel.notes[widget.index];

    Widget item = ChangeNotifierProvider<SingleNoteViewModel>.value(
      key: ValueKey(singleNote.note.id),
      value: singleNote,
      builder: (context, child) {
       SingleNoteViewModel viewModel= Provider.of<SingleNoteViewModel>(context);
       NotesViewModel notesViewModel = Provider.of<NotesViewModel>(context);
        return Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              Card(
                  elevation: 2,
                  color: Colors.red,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                      child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return _buildDialog(context,viewModel,notesViewModel );
                                });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          )))),
            ],
          ),
          child: NoteSingleItemContent(),
        );
      },
    );

    Widget header = Container();

    DateTime indexDay = DateTime(
      singleNote.note.timeCreated.year,
      singleNote.note.timeCreated.month,
      singleNote.note.timeCreated.day,
    );
    if (widget.index == 0) {
      header = ChangeNotifierProvider.value(
          value: singleNote, child: NoteDayHeader());
    } else {
      GenericNote prev = viewModel.notes[widget.index - 1].note;
      bool isSameDay = indexDay.isAtSameMomentAs(DateTime(
        prev.timeCreated.year,
        prev.timeCreated.month,
        prev.timeCreated.day,
      ));
      if (!isSameDay) {
        header = ChangeNotifierProvider.value(
            value: singleNote, child: NoteDayHeader());
      }
    }

    Widget main = Column(
      children: [header, item],
    );

    return main;
  }


  Widget _buildDialog(BuildContext context, SingleNoteViewModel note, NotesViewModel notesViewModel) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<NotesViewModel>.value(
        value: notesViewModel,),
    ChangeNotifierProvider<SingleNoteViewModel>.value(
    value: note,),
    ],
    builder: (context,child) {
      return AlertDialog(
        title: Text("Bạn có chắc chắc không?",
            style: TextStyle(color: Colors.red)),
        content: Text(
            "Hành động sẽ xóa toàn bộ thành phần này và không thể hoàn tác"),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
              child: Icon(Icons.cancel_outlined),
              onPressed: () => Navigator.of(context).pop()),
          TextButton(
            child: Icon(FontAwesomeIcons.trash, color: Colors.red),
            onPressed: () async {
              NotesViewModel viewModel =
              Provider.of<NotesViewModel>(context, listen: false);
              bool isOk = await viewModel.delete(
                  Provider.of<SingleNoteViewModel>(context, listen: false));
              if (isOk) {
                showSuccessMessage(context, "Xóa thành công");
                Navigator.of(context).pop(true);
              }
              else
                showErrMessage(context,
                    viewModel.error ?? Exception("Lỗi không xác định"));

              Navigator.pop(context);
            },
          ),
        ],
      );
    },);

  }
}

