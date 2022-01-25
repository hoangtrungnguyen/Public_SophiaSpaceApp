import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/view/page/note/note_detail.dart';

class NotesView extends StatefulWidget {
  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  ScrollController? _listController;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController()..addListener(_scrollListener);
    Future.microtask(() {
      Provider.of<NotesProvider>(context, listen: false).loadMoreNotes();
    });
  }

  @override
  void dispose() {
    _listController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_listController?.position.extentAfter == 0) {
      print("loadmore");
      Provider.of<NotesProvider>(context, listen: false).loadMoreNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      alignment: Alignment.center,
      child: Consumer<NotesProvider>(builder: (ctx, data, child) {
        if (data.notes.length == 0) {
          return Center(
            child: Text(
              "Hãy thêm ghi chú \nvề ngày của bạn tại đây",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          controller: _listController,
          itemCount: data.notes.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if(index == data.notes.length){
              return SizedBox(height: 50,);
            }
            return DailyNotes(
              note: data.notes[index],
            );
          },
        );
      }),
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
              contentPadding: EdgeInsets.zero,
              title: Text("${displayTitle()}"),
              subtitle: Text(
                  "${DateFormat.yMd().add_jm().format(note.timeCreated)} "),
            ),
            Wrap(

              children: note.emotions.length > 0
                  ? note.emotions.map((e) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Chip(
                          avatar: Icon(e.icon,color: Colors.grey,),
                            label: Text(e.name ?? "NaN",
                        style: Theme.of(context).textTheme.caption,)),
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
