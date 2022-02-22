import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/page/home/notes/note_view_holder.dart';
import 'package:sophia_hub/view/page/home/notes/single_item_note.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/single_note_view_model.dart';

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
    Provider.of<NotesViewModel>(context, listen: false).listKey = notesListKey;
    Provider.of<NotesViewModel>(context, listen: false).removedItemBuilder =
        _removalItemBuilder;
    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   Provider.of<NotesViewModel>(context,listen: false).listKey = notesListKey;
    // });
    Future.microtask(() {
      Provider.of<NotesViewModel>(context, listen: false).loadMore();
    });
  }

  @override
  void dispose() {
    _listNoteController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_listNoteController?.position.extentAfter == 0) {
      if (Provider.of<NotesViewModel>(context, listen: false).appConnectionState != ConnectionState.waiting) {
        Provider.of<NotesViewModel>(context, listen: false).loadMore();
      }
    } else if(_listNoteController?.position.pixels != null && Provider.of<NotesViewModel>(context, listen: false)
    .appConnectionState !=
    ConnectionState.waiting ){
      double pixels = _listNoteController?.position.pixels ?? 0;
      if( pixels < -90.0) {
        Provider.of<NotesViewModel>(context, listen: false).refresh();
      }
    }
  }


  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didUpdateWidget(NotesView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 100),
      child: Stack(
        children: [
          Center(
            child: Consumer<NotesViewModel>(
              builder: (_, value, child) =>
                  value.appConnectionState == ConnectionState.waiting &&
                          value.notes.length == 0
                      ? AnimatedLoadingIcon(size: 80)
                      : SizedBox(),
            ),
          ),
          Center(
            child: Consumer<NotesViewModel>(
              builder: (_, value, child) {
                return value.notes.length == 0 &&
                        value.appConnectionState != ConnectionState.waiting
                    ? Center(
                        child: Text(
                            "Hãy thêm ghi chú \nvề ngày của bạn tại đây",
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center))
                    : SizedBox();
              },
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Selector<NotesViewModel, bool>(
                builder: (_,value, child) => child ?? Container(),
                selector: (_,value) => value.isRefresh,
                shouldRebuild: (previous,next) {
                    return true;
                },
                child: _buildListNote(
                  context,
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildListNote(BuildContext context) {
    Widget groupListView = AnimatedList(
      key: notesListKey,
      initialItemCount: Provider.of<NotesViewModel>(context).notes.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: _buildSingleItem,
    );

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: _listNoteController,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<NotesViewModel, bool>(
              selector: (_,viewModel) => viewModel.isRefresh,
              builder: (_,value,child)=>  AnimatedContainer(
                margin: EdgeInsets.only(bottom: value ? 30 : 0),
                color: Theme.of(context).colorScheme.primary,
                duration: Duration(milliseconds: 300),
                height: value ? 150 : 0,
                  width: double.infinity,
                  child: AnimatedOpacity(
                    opacity: value ? 1.0 : 0,
                      duration: Duration(milliseconds: 500),
                      child: AnimatedLoadingIcon(size: 50,color: Colors.white,)))
            ),
            Padding(padding: EdgeInsets.only(bottom: 30), child: StatHeader()),
            groupListView,
            Center(
              child: Consumer<NotesViewModel>(
                  builder: (context, data, child) =>
                      data.appConnectionState == ConnectionState.waiting &&
                              data.notes.length > 0
                          ? AnimatedLoadingIcon()
                          : SizedBox()),
            ),
            SizedBox(height: 100,),
          ]),
    );
  }

  Widget _buildSingleItem(
      BuildContext context, int index, Animation<double> animation) {
    NotesViewModel viewModel =
        Provider.of<NotesViewModel>(context, listen: false);
    SingleNoteViewModel singleNote = viewModel.notes[index];
    Widget item = ChangeNotifierProvider<SingleNoteViewModel>.value(
      key: ValueKey(singleNote.note.id),
      value: singleNote,
      builder: (context, child) {
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
                                  return _buildDialog(context, singleNote);
                                });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          )))),
            ],
          ),
          child: NoteItem(),
        );
      },
    );

    Widget header = Container();

    DateTime indexDay = DateTime(
      singleNote.note.timeCreated.year,
      singleNote.note.timeCreated.month,
      singleNote.note.timeCreated.day,
    );
    if (index == 0) {
      header = ChangeNotifierProvider.value(
          value: singleNote, child: NoteDayHeader());
    } else {
      Note prev = viewModel.notes[index - 1].note;
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
    return FadeTransition(
        opacity: animation.drive(Tween<double>(begin: 0, end: 1)), child: main);
  }

  Widget _buildDialog(BuildContext context, SingleNoteViewModel note) {
    return ChangeNotifierProvider<SingleNoteViewModel>.value(
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
      },
    );
  }

  Widget _removalItemBuilder(
    SingleNoteViewModel removedItem,
    context,
    Animation animation,
  ) {
    var tween = Tween<Offset>(begin: Offset(-3, 0), end: Offset(0, 0));
    var sizeTween = Tween<double>(begin: 0, end:1);
    return
      SlideTransition(
        position: animation.drive(tween),
        child: SizeTransition(
          sizeFactor: animation.drive(sizeTween),
          child: ChangeNotifierProvider<SingleNoteViewModel>.value(
              value: removedItem, child: NoteItem()),
        )
    );
  }
}
