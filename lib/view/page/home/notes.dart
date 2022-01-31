import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/provider/ui_logic.dart';
import 'package:sophia_hub/view/page/home/notes/single_item_note.dart';

class NotesView extends StatefulWidget {
  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  ScrollController? _listNoteController;

  final notesListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _listNoteController = ScrollController()..addListener(_scrollListener);
    Provider.of<NotesPublisher>(context,listen: false).listKey = notesListKey;
    Provider.of<NotesPublisher>(context,listen: false).removedItemBuilder = _removalItemBuilder;
    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   Provider.of<NotesPublisher>(context,listen: false).listKey = notesListKey;
    // });
    Future.microtask(() {
      print("initial loading notes");
      Provider.of<NotesPublisher>(context, listen: false)
          .loadMoreNotes();

    });
  }

  @override
  void dispose() {
    _listNoteController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_listNoteController?.position.extentAfter == 0) {
      print("loadmore");
      Provider.of<NotesPublisher>(context, listen: false)
          .loadMoreNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 100),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Consumer<NotesPublisher>(builder: (ctx, data, child) {
              if (data.isLoading && data.notes.length == 0) {
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    Icons.cloud_download_outlined,
                    size: 100,
                    color: colorScheme.primary,
                  ),
                  Text("Loading...")
                ]);
              }

              if (data.notes.length == 0) {
                return Center(
                  child: Text(
                    "Hãy thêm ghi chú \nvề ngày của bạn tại đây",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Container();
            }),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildListNote(context))
        ],
      ),
    );
  }

  Widget _buildListNote(BuildContext context) {
    // TextStyle? head5 = Theme.of(context).textTheme.headline5;
    Widget groupListView = AnimatedList(
      key: notesListKey,
      initialItemCount:
          Provider.of<NotesPublisher>(context,listen: false).notes.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: _buildItem,
      controller: _listNoteController,
    );

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30), child: StatHeader()),
            groupListView
          ]),
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    // TextStyle? head5 = Theme.of(context).textTheme.headline5;
    NotesPublisher publisher =
        Provider.of<NotesPublisher>(context, listen: false);
    Note note = publisher.notes[index];
    print(note.activities);
    Widget item = ChangeNotifierProvider<Note>.value(
      key: ValueKey(note.id),
      value: note,
      builder: (context, child) {
        return Slidable(
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                Card(
                    color: Colors.red,
                    // margin: EdgeInsets.all(8),
                    // decoration: commonDecoration(Colors.red),
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return _buildDialog(context, note);
                                  });
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            )))),
              ],
            ),
            child: ChangeNotifierProvider.value(
              value: note,
              builder: (context,child) => DailyNotes(),
            ));
      },
    );

    Widget header = Container();

    DateTime indexDay = DateTime(
      note.timeCreated.year,
      note.timeCreated.month,
      note.timeCreated.day,
    );
    if (index == 0) {
      header = NoteDayHeader(
        e: note,
      );
    } else if (index > 0) {
      Note prev = publisher.notes[index - 1];
      bool isSameDay = indexDay.isAtSameMomentAs(DateTime(
        prev.timeCreated.year,
        prev.timeCreated.month,
        prev.timeCreated.day,
      ));
      if (!isSameDay) {
        header = NoteDayHeader(e: note);
      }
    }

    // if()

    Widget main = Column(
      children: [header, item],
    );
    return FadeTransition(
        opacity: animation.drive(Tween<double>(begin: 0, end: 1)), child: main);
  }

  Widget _buildDialog(BuildContext context, Note note) {
    return ChangeNotifierProvider<Note>.value(
      value: note,
      builder: (context, child) {
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
                NotesPublisher publisher =
                    Provider.of<NotesPublisher>(context, listen: false);
                try {
                  await publisher.delete(Provider.of<Note>(context, listen: false));

                } catch (e) {
                  print(e);
                  Flushbar(
                    backgroundColor:
                    Theme.of(context).colorScheme.error,
                    message: "Lỗi đã xảy ra, xin vui lòng thử lại sau",
                    flushbarPosition: FlushbarPosition.TOP,
                    borderRadius: BorderRadius.circular(16),
                    margin: EdgeInsets.all(8),
                    duration: Duration(seconds: 3),
                  )..show(context);
                } finally{
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _removalItemBuilder(Note removedItem, context,Animation animation,) {
    var tween = Tween<Offset>(begin: Offset(-1.50,0), end: Offset.zero);
  return
      SlideTransition(position: animation.drive(tween),
          child: ChangeNotifierProvider<Note>.value(
            value: removedItem,
              child: DailyNotes()));
  }
}
