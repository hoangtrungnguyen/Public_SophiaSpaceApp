import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view/page/home/notes/note_tab_animated_list_view.dart';
import 'package:sophia_hub/view/page/home/notes/note_tab_single_item_content.dart';
import 'package:sophia_hub/view/page/home/notes/note_tab_statistic.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view/widget/spinning_ring.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

class NoteTabView extends StatefulWidget {
  const NoteTabView({Key? key}) : super(key: key);

  @override
  _NoteTabViewState createState() => _NoteTabViewState();
}

class _NoteTabViewState extends State<NoteTabView> {
  ScrollController? _listNoteController;

  @override
  void initState() {
    super.initState();
    _listNoteController = ScrollController();

    Provider.of<NotesViewModel>(context, listen: false).removedItemBuilder =
        _removalItemBuilder;
    Provider.of<NotesViewModel>(context, listen: false).clearanceItemBuilder =
        _clearanceItemBuilder;
    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   Provider.of<NotesViewModel>(context,listen: false).listKey = notesListKey;
    // });
    Future.microtask(() async {
      await Provider.of<NotesViewModel>(context, listen: false)
          .loadMore()
          .then((value) => {_listNoteController?.addListener(_scrollListener)});
    });
  }

  @override
  void dispose() {
    _listNoteController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final notesViewModel = Provider.of<NotesViewModel>(context, listen: false);
    if (_listNoteController?.position.extentAfter == 0 && notesViewModel
    .appConnectionState != ConnectionState.waiting && notesViewModel.notes.length > 3) {
        notesViewModel.loadMore();
    } else if (_listNoteController?.position.pixels != null &&
        notesViewModel.appConnectionState != ConnectionState.waiting) {
      double pixels = _listNoteController?.position.pixels ?? 0;
      // double pixels = _listNoteController?.position.outOfRange.pixels ?? 0;
      if (pixels < -90.0) {
        notesViewModel.refresh();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 100),
      child: Stack(
        children: [

          Center(
            child: Consumer<NotesViewModel>(
              builder: (context, value, child) =>
                  value.appConnectionState == ConnectionState.waiting &&
                          value.notes.length == 0 &&
                          !value.isRefreshing
                      ? AnimatedLoadingIcon(size: 80)
                      : SizedBox(),
            ),
          ),
          Center(
            child: Consumer<NotesViewModel>(
              builder: (context, value, child) {
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
            child: _buildListNote(
              context,
            ),
          )
        ],
      ),
    );

    return content;
  }

  Widget _buildListNote(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: _listNoteController,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<NotesViewModel, bool>(
                selector: (_, viewModel) => viewModel.isRefreshing,
                builder: (_, value, child) => AnimatedContainer(
                    margin: EdgeInsets.only(bottom: value ? 30 : 0),
                    color: Theme.of(context).colorScheme.primary,
                    duration: Duration(milliseconds: 500),
                    height: value ? 150 : 0,
                    width: double.infinity,
                    child: AnimatedOpacity(
                        opacity: value ? 1.0 : 0,
                        duration: Duration(milliseconds: 500),
                        child: AnimatedLoadingIcon(
                          size: 50,
                          color: Colors.white,
                        )))),
            Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: NoteTabStatistic()),
            NoteTabAnimatedListView(),
            Center(
              child: Consumer<NotesViewModel>(
                  builder: (context, data, child) =>
                      data.appConnectionState == ConnectionState.waiting &&
                              data.notes.length > 0
                          ? AnimatedLoadingIcon()
                          : SizedBox()),
            ),
            SizedBox(
              height: 100,
            ),
          ]),
    );
  }

  Widget _removalItemBuilder(
    SingleNoteViewModel removedItem,
    context,
    Animation animation,
  ) {
    var tween = Tween<Offset>(begin: Offset(-3, 0), end: Offset(0, 0));
    var sizeTween = Tween<double>(begin: 0, end: 1);
    return SlideTransition(
        position: animation.drive(tween),
        child: SizeTransition(
          sizeFactor: animation.drive(sizeTween),
          child: ChangeNotifierProvider<SingleNoteViewModel>.value(
              value: removedItem, child: NoteSingleItemContent()),
        ));
  }

  Widget _clearanceItemBuilder(
    SingleNoteViewModel removedItem,
    context,
    Animation animation,
  ) {
    var opacity = Tween<double>(begin: 0, end: 1);
    return FadeTransition(
        opacity: animation.drive(opacity),
        child: IgnorePointer(
          child: ChangeNotifierProvider<SingleNoteViewModel>.value(
              value: removedItem, child: NoteSingleItemContent()),
        ));
  }
}
