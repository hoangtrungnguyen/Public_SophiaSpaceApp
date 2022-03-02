import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/page/note/note_detail/note_detail.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';


class NoteDayHeader extends StatefulWidget {
  const NoteDayHeader({Key? key}) : super(key: key);

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
    SingleNoteViewModel manager = Provider.of<SingleNoteViewModel>(context);
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
                    manager.note.timeCreated,
                  )}",
                ),
                Text(
                  "${DateFormat.MMM('vi').format(manager.note.timeCreated)}",
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            )),
        title:
            Text("${DateFormat.EEEE('vi').format(manager.note.timeCreated)}"),
        subtitle:
            Text("${DateFormat.y('vi').format(manager.note.timeCreated)}"),
      ),
    );
  }
}

class NoteSingleItemContent extends StatefulWidget {
  NoteSingleItemContent({Key? key}) : super(key: key);

  @override
  State<NoteSingleItemContent> createState() => _NoteSingleItemContentState();
}

class _NoteSingleItemContentState extends State<NoteSingleItemContent>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    SingleNoteViewModel manager = Provider.of<SingleNoteViewModel>(context);
    Widget content = Container();
    if (manager.note is Note) {
      Note note = manager.note as Note;
      content = Padding(
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
              elevation: MaterialStateProperty.all<double?>(4),
              backgroundColor: MaterialStateProperty.all<Color?>(Colors.white)),
          onPressed: () {
            Navigator.push(context, NoteDetails.route(note,
            Provider.of<NotesViewModel>(context,listen: false)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: note.emotionPoint == null
                    ? CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey,
                      )
                    : Icon(
                        generateMoodIcon(note.emotionPoint!),
                        size: 36,
                      ),
                contentPadding: EdgeInsets.zero,
                title: Text("${displayTitle(note)}"),
                subtitle: Text("${DateFormat.jm().format(note.timeCreated)} "),
              ),
              Wrap(children: activityChips(note),)
            ],
          ),
        ),
      );
    } else {}
    return content;
  }

  List<Widget> activityChips(Note note) {
    return [
      ...note.activities.map((Activity e) {
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
    ];
  }

  String displayTitle(Note note) {
    String? title = note.title;
    int? emotionPoint = note.emotionPoint;
    String status;
    if (title != null) if (title.isNotEmpty) return title;
    if(emotionPoint == null){
      status = "";
    } else if (2 > emotionPoint && emotionPoint >= 0) {
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
