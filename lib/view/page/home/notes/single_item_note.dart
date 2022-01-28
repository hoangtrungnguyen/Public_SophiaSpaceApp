import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/view/page/note/note_detail.dart';

class StatHeader extends StatelessWidget {
  const StatHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            child: Text(
              "Nhật ký của bạn",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.apply(color: Colors.grey.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
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

class NoteDayHeader extends StatefulWidget {
  final Note e;

  const NoteDayHeader({Key? key, required this.e}) : super(key: key);

  @override
  State<NoteDayHeader> createState() => _NoteDayHeaderState();
}

class _NoteDayHeaderState extends State<NoteDayHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this)
          ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: ListTile(
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
      ),
    );
  }
}

class DailyNotes extends StatefulWidget {
  final Note note;

  DailyNotes({Key? key, required this.note}) : super(key: key);

  @override
  State<DailyNotes> createState() => _DailyNotesState();
}

class _DailyNotesState extends State<DailyNotes>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
              EdgeInsets.symmetric(horizontal: 16),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder?>(
                ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            )),
            elevation: MaterialStateProperty.all<double?>(8),
            backgroundColor: MaterialStateProperty.all<Color?>(Colors.white)),
        onPressed: () {
          Navigator.pushNamed(context, NoteDetails.nameRoute,
              arguments: widget.note);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                generateMoodIcon(widget.note.emotionPoint),
                size: 36,
              ),
              contentPadding: EdgeInsets.zero,
              title: Text("${displayTitle()}"),
              subtitle:
                  Text("${DateFormat.jm().format(widget.note.timeCreated)} "),
            ),
            Wrap(
              children: [
                ...widget.note.activities.map((e) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                        elevation: 0,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        padding: EdgeInsets.zero,
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
              ],
            )
          ],
        ),
      ),
    );
  }

  String displayTitle() {
    String? title = widget.note.title;
    int emotionPoint = widget.note.emotionPoint;
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
