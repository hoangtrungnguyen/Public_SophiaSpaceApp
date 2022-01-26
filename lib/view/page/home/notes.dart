import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/view/page/note/note_detail.dart';

class NotesView extends StatefulWidget {
  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  ScrollController? _listNoteController;

  @override
  void initState() {
    super.initState();
    _listNoteController = ScrollController()..addListener(_scrollListener);
    Future.microtask(() {
      Provider.of<NotesProvider>(context, listen: false).loadMoreNotes();
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
      Provider.of<NotesProvider>(context, listen: false).loadMoreNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(top: 100),
      alignment: Alignment.topCenter,
      child: Consumer<NotesProvider>(builder: (ctx, data, child) {
        if (data.isLoading && data.notes.length == 0) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              Icons.cloud_download_outlined,
              size: 100,
              color: colorScheme.primary,
            ),
            Text("Loading...")
          ]));
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

        Widget groupListView = GroupedListView<Note, DateTime>(
          elements: data.notes,
          order: GroupedListOrder.DESC,
          groupBy: (Note e) => DateTime(
            e.timeCreated.year,
            e.timeCreated.month,
            e.timeCreated.day, /*e.timeCreated.hour*/
          ),
          groupSeparatorBuilder: (e) => SizedBox(
            height: 40,
          ),
          shrinkWrap: true,
          groupHeaderBuilder: (e) => _Header(e: e),
          itemBuilder: (context, Note e) => Slidable(
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  Card (
                    color: Colors.red,
                    // padding: EdgeInsets.all(8),
                    // decoration: commonDecoration(Colors.red),
                    child: Padding(padding: EdgeInsets.all(12),
                    child: Icon(Icons.delete,color: Colors.white, size: 35,))
                  ),
                ],
              ),
              child: DailyNotes(note: e)),
          controller: _listNoteController,
        );

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:[
              _StatHeader(),
              groupListView
            ]
          ),
        );
      }),
    );
  }

  _buildListNote() {}
}


class _StatHeader extends StatelessWidget {
  const _StatHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            child: Text("Nhật ký của bạn",
              style: Theme.of(context).textTheme.headline4?.apply(
                  color: Colors.grey.withOpacity(0.8)
              ),
              textAlign: TextAlign.center,),
            alignment: Alignment.topCenter,
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Card(
          //     elevation: 12,
          //     child: Container(
          //         height: 100,
          //         child: ListTile(
          //           title: Text("Nhật ký của bạn",style:
          //           Theme.of(context).textTheme.headline5),
          //           subtitle: Text(""),
          //         )
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}



class _Header extends StatefulWidget {
  final Note e;

  const _Header({Key? key, required this.e}) : super(key: key);

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.only(top: 5),
          width: 50,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          child: Column(
            children: [
              Text(
                "${DateFormat.d('vi').format(
                  widget.e.timeCreated,
                )}",
              ),
              Text(
                "${DateFormat.MMM('vi').format(widget.e.timeCreated)}",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          )),
      title: Text("${DateFormat.EEEE('vi').format(widget.e.timeCreated)}"),
      subtitle: Text("${DateFormat.y('vi').format(widget.e.timeCreated)}"),
    );
  }
}

class DailyNotes extends StatelessWidget {
  final Note note;

  DailyNotes({required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
              EdgeInsets.symmetric(horizontal: 16),
            ),
            shape:MaterialStateProperty.all<OutlinedBorder?>(
                ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                )
            ) ,
            elevation: MaterialStateProperty.all<double?>(8),
            backgroundColor: MaterialStateProperty.all<Color?>(Colors.white)),
        onPressed: () {
          Navigator.pushNamed(context, NoteDetails.nameRoute, arguments: note);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              leading: Icon(
                generateMoodIcon(note.emotionPoint),
                size: 36,
              ),
              contentPadding: EdgeInsets.zero,
              title: Text("${displayTitle()}"),
              subtitle: Text("${DateFormat.jm().format(note.timeCreated)} "),
            ),
            Wrap(
              children: note.activities.length > 0
                  ? note.activities.map((e) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Chip(
                            avatar: Icon(
                              e.icon,
                              color: Colors.grey,
                            ),
                            label: Text(
                              e.name ?? "NaN",
                              style: Theme.of(context).textTheme.caption,
                            )),
                      );
                    }).toList()
                  : [],
            )
          ],
        ),
      ),
    );
  }

  String displayTitle() {
    String? title = note.title;
    int emotionPoint = note.emotionPoint;
    String status;
    if (title != null) if (title.isNotEmpty) return title;

    assert(emotionPoint >= 0 || emotionPoint < 10, 'Out of bound');
    if (2 > emotionPoint && emotionPoint >= 0) {
      status = "Rất tệ";
    } else if (4 > emotionPoint && emotionPoint >= 2) {
      status = "Hơi tệ";
    } else if (5 > emotionPoint && emotionPoint >= 4) {
      status = "Tạm ổn";
    } else if (7 > emotionPoint && emotionPoint >= 5) {
      status = "Tốt";
    } else if (9 > emotionPoint && emotionPoint >= 7) {
      status = "Rất tốt";
    } else {
      status = "Tuyệt vời";
    }

    return status;
  }
}
