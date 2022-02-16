import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/note_state_manager.dart';
import 'package:sophia_hub/provider/single_note_state_manager.dart';
import 'package:sophia_hub/view/page/home/notes/single_item_note.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';

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
    Provider.of<NotesStateManager>(context, listen: false).listKey =
        notesListKey;
    Provider.of<NotesStateManager>(context, listen: false).removedItemBuilder =
        _removalItemBuilder;
    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   Provider.of<NotesStateManager>(context,listen: false).listKey = notesListKey;
    // });
    Future.microtask(() {
      Provider.of<NotesStateManager>(context, listen: false).loadMore();
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
      Provider.of<NotesStateManager>(context, listen: false).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    NotesStateManager manager = Provider.of<NotesStateManager>(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 100),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<ConnectionState>(builder: (ctx, snapshot) {
              bool isLoading = snapshot.data == ConnectionState.waiting;
              if (isLoading)
                return AnimatedLoadingIcon(
                  size: 50,
                );

              if (manager.notes.length == 0)
                return Center(
                  child: Text(
                    "Hãy thêm ghi chú \nvề ngày của bạn tại đây",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                );

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
    Widget groupListView = AnimatedList(
      key: notesListKey,
      initialItemCount: Provider.of<NotesStateManager>(context, listen: false).notes.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: _buildSingleItem,
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

  Widget _buildSingleItem(
      BuildContext context, int index, Animation<double> animation) {
    // TextStyle? head5 = Theme.of(context).textTheme.headline5;
    NotesStateManager manager =
        Provider.of<NotesStateManager>(context, listen: false);
    SingleNoteManager singleNoteManager = manager.notes[index];
    // print(note.activities);
    Widget item = ChangeNotifierProvider<SingleNoteManager>.value(
      key: ValueKey(singleNoteManager.note.id),
      value: singleNoteManager,
      builder: (context, child) {
        return Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              Card(
                  color: Colors.red,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                      child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return _buildDialog(
                                      context, singleNoteManager);
                                });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          )))),
            ],
          ),
          child: DailyNotes(),
        );
      },
    );

    Widget header = Container();

    DateTime indexDay = DateTime(
      singleNoteManager.note.timeCreated.year,
      singleNoteManager.note.timeCreated.month,
      singleNoteManager.note.timeCreated.day,
    );
    if (index == 0) {
      header = ChangeNotifierProvider.value(
          value: singleNoteManager, child: NoteDayHeader());
    } else {
      Note prev = manager.notes[index - 1].note;
      bool isSameDay = indexDay.isAtSameMomentAs(DateTime(
        prev.timeCreated.year,
        prev.timeCreated.month,
        prev.timeCreated.day,
      ));
      if (!isSameDay) {
        header = ChangeNotifierProvider.value(
            value: singleNoteManager, child: NoteDayHeader());
      }
    }

    Widget main = Column(
      children: [header, item],
    );
    return FadeTransition(
        opacity: animation.drive(Tween<double>(begin: 0, end: 1)), child: main);
  }

  Widget _buildDialog(BuildContext context, SingleNoteManager note) {
    return ChangeNotifierProvider<SingleNoteManager>.value(
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
                NotesStateManager publisher =
                    Provider.of<NotesStateManager>(context, listen: false);
                bool isOk = await publisher.delete(
                    Provider.of<SingleNoteManager>(context, listen: false));
                if(isOk)
                  showSuccessMessage(context,"Xóa thành công");
                else
                  showErrMessage(context, publisher.error ?? Exception("Lỗi không xác định"));

                Navigator.pop(context);



              },
            ),
          ],
        );
      },
    );
  }

  Widget _removalItemBuilder(
    SingleNoteManager removedItem,
    context,
    Animation animation,
  ) {
    var tween = Tween<Offset>(begin: Offset(-1.50, 0), end: Offset.zero);
    return SlideTransition(
        position: animation.drive(tween),
        child: ChangeNotifierProvider<SingleNoteManager>.value(
            value: removedItem, child: DailyNotes()));
  }
}
